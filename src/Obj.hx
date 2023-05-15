// game object

class Obj
{
  var game: Game;
  var scene: Scene;
  public var parent(default, null): Obj;
  public var children(default, null): Array<Obj>;
  var state(get, null): ParserState;
  var action(get, null): _Action;
  var actor(get, null): Obj;
  var first(get, null): Obj;
  var second(get, null): Obj;
  var dir(get, null): _CompassDirection;
  var attrs: Array<_Attribute>;

  public var type: String;
  public var id: String;
  public var name: String;
  public var theName(get, null): String;
  public var TheName(get, null): String;
  public var aName(get, null): String;
  public var names: Array<String>;
//  public var foundIn: Array<String>;
// linked object in another location
// for example, other side of the same door
  public var linkedObj: Obj;

  public function new(parent: Obj)
    {
      this.parent = parent;
      if (parent != null) // root object has parent null
        {
          game = @:privateAccess parent.game;
          scene = findScene();
        }
      type = 'object';
      id = 'OBJECT';
      name = 'OBJECT';
      desc = '';
      names = [ 'OBJECT' ];
//      foundIn = [];
      children = [];
      attrs = [ STATIC ];
    }

/**
_String or routine_   `"a"`
_For objects_   Indefinite article for object or routine to print one.  
_No return value_
**/
  public var article: String;

/*
String or routine_
_For objects_   The description of an object not yet picked up, used when a room is described; or a routine to print one out.  
_For rooms_   Printed or run when the room is arrived in, either by ordinary movement or by `PlayerTo`.  
_Warning_   If the object is a `door`, or a `container`, or is `switchable`, then use one of the `when_` properties rather than `initial`.  
_No return value

Example:
initial "A handwritten envelope, recently delivered, is lying on the table.",
"Beside the skeleton is a rusty knife."
*/
  public var initial: String;
  function initialF(): String
    {
      return '';
    }

/**
_String or routine_
_For objects_   The `Examine` message, or a routine to print one out.  
_For rooms_   The long (“look”) description, or a routine to print one out.  
_No return value
**/
  public var desc: String;
  function descF(): String
    {
      var s = desc;
      if (s == '')
        s = 'You see nothing special about ' + theName + '.';
      // add children
      s += descChildren();
      return s;
    }

// add children to desc/describe lines
  function descChildren(): String
    {
      var s = '';
      // searchable objects that were searched
      // will print found contents after that
      if (hasAttr(SEARCHED))
        {
          var tmp = [];
          for (ch in children)
            if (!ch.hasAttr(CONCEALED))
              tmp.push(ch);
          s += ' It contains ' +
            stringChildrenPartial(tmp) + '.';
        }
      return s;
    }

/**
_Routine_   `NULL`   (+)
_For objects_   Called when the object is to be described in a room description, before any paragraph break (i.e., skipped line) has been printed. A sometimes useful trick is to print nothing in this routine and return `true`, which makes an object 'invisible'.  
_For rooms_   Called before a room's long (“look”) description is printed.  
_Routine returns_   `false` to describe in the usual way, `true` to stop printing here.

Example:
describe "There are holes in the soft dirt near your feet.",
**/
  public var describe: String;
  function describeF(): String
    {
      var s = '';
//      debug('describeF');
      // door descriptions
      if (hasAttr(DOOR))
        {
          if (hasAttr(OPEN))
            {
              if (whenOpen != null &&
                  whenOpen != '')
                s += whenOpen;
              else if (whenOpenF != null)
                s += whenOpenF();
              // default
              s += TheName + ' is open.';
            }
          else
            {
              if (whenClosed != null &&
                  whenClosed != '')
                s += whenClosed;
              else if (whenClosedF != null)
                s += whenClosedF();
              // default
              s += TheName + ' is closed.';
            }
        }
      else
        {
/*
          if (initial != null && initial != '')
            return initial;
          var initial*/
          if (describe != null && describe != '')
            s += describe;
          else s += 'There is ' + aName + ' here.';
        }
      // add children
      s += descChildren();

      return s;
    }

// runs before every command
// returns true on success and continues
// stops working on false
/**
_Routine_   `NULL`   (+)
Receives advance warning of actions (or fake actions) about to happen.  
_For rooms_   All actions taking place in this room.  
_For objects_   All actions for which this object is `noun` (the first object specified in the command); and all fake actions, such as `Receive` and `LetGo` if this object is the container or supporter concerned.  
_Routine returns_   `false` to continue with the action, `true` to stop here (printing nothing).

First special case: A vehicle object receives the `Go` action if the player is trying to drive around in it. In this case:  
_Routine returns_   0 to disallow as usual; 1 to allow as usual, moving vehicle and player; 2 to disallow but do (and print) nothing; 3 to allow but do (and print) nothing. If you want to move the vehicle in your own code, return 3, not 2: otherwise the old location may be restored by subsequent workings.  
Second special case: in a `PushDir` action, the `before` routine must call `AllowPushDir()` and then return `true` in order to allow the attempt (to push an object from one room to another) to succeed.
**/
  public function before(): Bool
    {
      if (first != null && first != this)
        return true;
      switch (action)
        {
          case CLOSE:
            if (!hasAttr(OPENABLE))
              {
                p("That's not something you can close.");
                return false;
              }
            if (!hasAttr(OPEN))
              {
                p("That's already closed.");
                return false;
              }
          case DROP:
            if (parent != actor)
              {
                p("That is already here.");
                return false;
              }
          case EAT:
            if (parent != actor)
              {
                p("You don't have that on you.");
                return false;
              }
            if (!hasAttr(EDIBLE))
              {
                p("That's plainly inedible.");
                return false;
              }
          case OPEN:
            if (!hasAttr(OPENABLE))
              {
                p("That's not something you can open.");
                return false;
              }
            if (hasAttr(LOCKED))
              {
                p("It seems to be locked.");
                return false;
              }
            if (hasAttr(OPEN))
              {
                p("That's already open.");
                return false;
              }
          case SEARCH:
            if (hasAttr(SEARCHED))
              {
                p("You have already searched that.");
                return false;
              }
          case TAKE:
            if (parent == actor)
              {
                p("You already have that.");
                return false;
              }
            if (hasAttr(STATIC))
              {
                p("That's fixed in place.");
                return false;
              }
          default:
        }
      return true;
    }

// actual command handling
  function during()
    {
//      debug('obj.during');
      switch (action)
        {
          case CLOSE:
            unsetAttr(OPEN);
          case DROP:
            moveTo(actor.getRoom());
          case EAT:
            destroy();
          case OPEN:
            setAttr(OPEN);
          case SEARCH:
            // find stuff - unhide it
            if (hasAttr(SEARCHABLE))
              {
                var tmp = [];
                for (ch in children)
                  if (ch.hasAttr(HIDDEN))
                    {
                      ch.unsetAttr(HIDDEN);
                      tmp.push(ch);
                    }
                p('Searching through ' + theName +
                  ', you find ' + stringChildrenPartial(tmp) + '.');
                setAttr(SEARCHED);
              }
          case TAKE:
            moveTo(actor);
            if (!hasAttr(MOVED))
              setAttr(MOVED);
          default:
        }
    }

/**
_Routine_   `NULL`   (+)
Receives actions after they have happened, but before the player has been told of them.  
_For rooms_   All actions taking place in this room.  
_For objects_   All actions for which this object is `noun` (the first object specified in the command); and all fake actions for it.  
_Routine returns_   `false` to continue (and tell the player what has happened), `true` to stop here (printing nothing).  
The `Search` action is a slightly special case. Here, `after` is called when it is clear that it would be sensible to look inside the object (e.g., it's an open container in a light room) but before the contents are described.
**/
  public function after(): String
    {
      switch (action)
        {
          case CLOSE:
            return "You close " + theName + ".";
          case DROP:
            return 'Dropped.';
          case EAT:
            return 'You eat ' + theName + '. Not bad.';
          case EXAMINE:
            return descF();
          case INVENTORY:
            if (actor.children.length == 0)
              return "You are carrying nothing.";
            return 'You are carrying ' +
              actor.stringChildren() + '.';
          case OPEN:
            if (hasAttr(CONTAINER))
              return "You open " + theName + ", revealing " + stringChildren();
            else return "You open " + theName + ".";
          case RUB:
            return "You achieve nothing by this.";
          case SEARCH:
            // suppress after the successful action 
            if (hasAttr(SEARCHED))
              return '';
            return "You find nothing of interest.";
          case SMELL:
            return "You smell nothing unexpected.";
          case TAKE:
            return 'Taken.';
          case TOUCH:
            return "You feel nothing unexpected.";
          default:
            debug('default message');
        }
      return 'DEFAULT MESSAGE';
    }

// move this object to another parent
  public function moveTo(target: Obj)
    {
      // first entry - dm narration
      var callEnter = false;
      if (this == game.party)
        {
          if (game.party.scene != target.scene)
            callEnter = true;
        }
      parent.children.remove(this);
      target.children.push(this);
      parent = target;
      scene = target.scene;
      if (callEnter)
        scene.enter();

      // moving player party will run description
      if (this == game.party)
        {
//          debug('moveTo ' + target);
          var s = target.initialF();
          if (s != '')
            p(s);
        }
    }

// find object by id traversing children
  public function findObject(idv: String): Obj
    {
      for (ch in children)
        {
          if (ch.id == idv)
            return ch;
          var o = ch.findObject(idv);
          if (o != null && o.id == idv)
            return o;
        }
      return null;
    }

// traverse parents up until we find a scene
  function findScene(): Scene
    {
      var p = parent;
      while (p != null && p.type != 'scene')
        p = p.parent;
      if (p != null)
        return cast(p, Scene);
      return null;
    }

// add child to list of children
  public function addChild(o: Obj)
    {
      children.push(o);
    }

// get child by id
  public function getChild(id: String): Obj
    {
      for (ch in children)
        if (ch.id == id)
          return ch;
      return null;
    }

// get scene through parent
  public function getScene(): Scene
    {
      var p = this.parent;
      while (p != null && p.type != 'scene')
        p = p.parent;
      if (p == null)
        {
//          error('Not in scene.');
          return null;
        }
      return p.asScene();
    }

// get room through parent
  public function getRoom(): Room
    {
      var p = this.parent;
      while (p.type != 'room' && p != null)
        p = p.parent;
      if (p == null)
        {
          error('Not in room.');
          return null;
        }
      return p.asRoom();
    }

// run current action (called externally and propagated to target object - room, room object, inventory object, etc)
  public function runAction(): Bool
    {
//      debug('runAction()');
      // run pre-action checks
      var ok = before();
      if (!ok)
        return false;
      // actual work
      during();
      // run post-action (mostly custom messages)
      var msg = after();
      if (msg != '')
        print(msg);
      return true;
    }

// get a string with partial list of children
  public function stringChildren(): String
    {
      return stringChildrenPartial(children);
    }

// get a string with list of children
  public function stringChildrenPartial(list: Array<Obj>): String
    {
      var s = '';
      for (i in 0...list.length)
        {
          var ch = list[i];
          s += ch.aName;
          if (list.length == 1)
            continue;

          if (i == list.length - 2)
            s += ' and ';
          else if (i != list.length - 1)
            s += ', ';
        }
      return s;
    }

// returns true if this object has this attribute
  public function hasAttr(a: _Attribute): Bool
    {
      return (attrs.indexOf(a) >= 0);
    }

// sets the given attribute
  public function setAttr(a: _Attribute)
    {
      if (hasAttr(a))
        {
          error('Already has attribute ' + a + '.');
          return;
        }
      attrs.push(a);
      if (linkedObj != null)
        linkedObj.attrs.push(a);
    }

// unsets the given attribute
  public function unsetAttr(a: _Attribute)
    {
      if (!hasAttr(a))
        {
          error('Does not have attribute ' + a + '.');
          return;
        }
      attrs.remove(a);
      if (linkedObj != null)
        linkedObj.attrs.remove(a);
    }

// sets the given attributes from a list
  public function setAttrs(list: Array<_Attribute>)
    {
      for (a in list)
        {
          if (hasAttr(a))
            {
              error('Already has attribute ' + a + '.');
              return;
            }
          attrs.push(a);
        }
    }

// additional post-object creation init
  public function init()
    {
      for (ch in children)
        ch.init();
    }

// convert string field to object and set it
  public function stringToObject(f: String): Obj
    {
      var id:String = Reflect.field(this, f);
      if (id == null || id == '')
        return null;
      var val = scene.findObject(id);
      if (val == null)
        error('Could not find object ' + id + ' in this scene.');
      Reflect.setField(this, f + 'Obj', val);
      return val;
    }

// destroys the object
  public function destroy()
    {
      parent.children.remove(this);
      parent = null;
    }

// print string
  public inline function p(s: String)
    {
      game.console.print(s);
    }

// get state
  function get_state()
    {
      return game.parserState;
    }

// get name with 'the' article
  function get_theName()
    {
      return 'the ' + name;
    }

// get titled name with 'the' article
  function get_TheName()
    {
      return 'The ' + name;
    }

// get name with 'a' article
  function get_aName()
    {
      return (article != null ? article : 'a') + ' ' + name;
    }

  function get_action()
    {
      return state.action;
    }

  function get_actor()
    {
      return state.actor;
    }

  function get_first()
    {
      return state.first;
    }

  function get_second()
    {
      return state.second;
    }

  function get_dir()
    {
      return state.dir;
    }

  inline function print(s: String)
    {
      game.console.print(s);
    }

  inline function debug(s: String)
    {
      game.console.debug(toString() + ': ' + s);
    }

  inline function error(s: String)
    {
      game.console.error(toString() + ': ' + s);
    }

// casters
  public inline function asRoom(): Room
    {
      return cast(this, Room);
    }
  public inline function asScene(): Scene
    {
      return cast(this, Scene);
    }

  public function toString(): String
    {
      return id + ' [' + type + ']';
    }

/*
_String or routine_
_For objects_   Description, or routine to print one, of something closed (a `door` or `container`) in a room's long description.  
_No return value_
*/
  public var whenClosed: String;
  public var whenClosedF: Void -> String;
/*
String or routine_
_For objects_   Description, or routine to print one, of something open (a `door` or `container`) in a room's long description.  
_No return value
*/
  public var whenOpen: String;
  public var whenOpenF: Void -> String;
}
