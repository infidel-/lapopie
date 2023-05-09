// game object

class Obj
{
  var game: Game;
  var scene: Scene;
  var parent: Obj;
  var children: Array<Obj>;
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
/**
_String or routine_
_For objects_   The `Examine` message, or a routine to print one out.  
_For rooms_   The long (“look”) description, or a routine to print one out.  
_No return value
**/
  public var desc: String;

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
      desc = 'OBJECT';
      names = [ 'OBJECT' ];
//      foundIn = [];
      children = [];
      attrs = [ STATIC ];
    }

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
//      debug('describeF');
      // door descriptions
      if (hasAttr(DOOR))
        {
          if (hasAttr(OPEN))
            {
              if (whenOpen != null &&
                  whenOpen != '')
                return whenOpen;
              else if (whenOpenF != null)
                return whenOpenF();
              // default
              return TheName + ' is open.';
            }
          else
            {
              if (whenClosed != null &&
                  whenClosed != '')
                return whenClosed;
              else if (whenClosedF != null)
                return whenClosedF();
              // default
              return TheName + ' is closed.';
            }
        }
      else
        {
/*
          if (initial != null && initial != '')
            return initial;
          var initial*/
          if (describe != null && describe != '')
            return describe;
          else return 'There is ' + aName + ' here.';
        }
      return '';
    }

// runs before every command
// returns true on success and continues
// stops working on false
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
          case TAKE:
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
          case OPEN:
            setAttr(OPEN);
          case CLOSE:
            unsetAttr(OPEN);
          case TAKE:
            moveTo(actor);
          default:
        }
    }

// runs after every command
// returns string to print
  public function after(): String
    {
      switch (action)
        {
          case CLOSE:
            return "You close " + theName + ".";
          case EXAMINE:
            return desc;
          case OPEN:
            if (hasAttr(CONTAINER))
              return "You open " + theName + ", revealing " + stringChildren();
            else return "You open " + theName + ".";
          case TAKE:
            return 'Taken.';
          default:
            debug('default message');
        }
      return 'DEFAULT MESSAGE';
    }

// move this object to another parent
  public function moveTo(target: Obj)
    {
      parent.children.remove(this);
      target.children.push(this);
      parent = target;

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

// get a string with list of children
  public function stringChildren(): String
    {
      var tmp = [];
      for (ch in children)
        tmp.push(ch.aName);
      return tmp.join(', ');
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
  public function stringToObject(f: String)
    {
      var id:String = Reflect.field(this, f);
      if (id == null || id == '')
        return; 
      var val = scene.findObject(id);
      if (val == null)
        error('Could not find object ' + id + ' in this scene.');
      Reflect.setField(this, f + 'Obj', val);
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
      return 'a ' + name;
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

  public inline function asRoom(): Room
    {
      return cast(this, Room);
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
