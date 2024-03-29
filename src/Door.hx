// scene -> door
class Door extends Obj
{
/**
_Room or routine_

_For objects_   The place this door object leads to. A value of 0 means “leads nowhere”.  
_Routine returns_   The room. Again, 0 (or `false`) means “leads nowhere”. Further, 1 (or `true`) means “stop the movement action immediately and print nothing further”.
**/
  public var doorTo: String;
  public var doorToObj: Obj;
/**
_Direction property or routine_

_For compass objects_   When the player tries to go in this direction, e.g., by typing the name of this object, then the map connection tried is the value of this direction property for the current room. For example, the `n_obj` “north” object normally has `door_dir` set to `n_to`.  
_For objects_   The direction that this `door` object goes via (for instance, a bridge might run east, in which case this would be set to `e_to`).  
_Routine returns_   The direction property to try.  
**/
  public var doorDir: _CompassDirection;

  public function new(parent: Obj)
    {
      super(parent);
      type = 'door';
      setAttrs([ DOOR, OPENABLE ]);
    }

  override function before()
    {
      switch (action)
        {
          case ENTER, GO:
            if (!hasAttr(OPEN))
              {
                p("You can't, since " + theName + " is closed.");
                return false;
              }
            if (doorToObj == null)
              {
                p("It leads nowhere.");
                return false;
              }
          default:
            return super.before();
        }
      return true;
    }

  override function during()
    {
//      debug('door.during ' + action);
      switch (action)
        {
          case ENTER, GO:
            game.party.moveTo(doorToObj);
          default:
//            debug('default');
            super.during();
        }
    }

  override function after()
    {
      switch (action)
        {
          case GO, ENTER:
            return '';
          default:
            return super.after();
        }
      return '';
    }

  public override function init()
    {
      super.init();

      // string to objects for quicker access
      stringToObject('doorTo');
      // add to temp list of init doors
      // to create their other sides
      scene.initDoors.push(this);
    }

// make a linked door
  public function link()
    {
      // not really a door
      if (doorDir == null ||
          doorTo == null)
        return;

      var doorClass = Type.getClass(this);
      var link = Type.createInstance(doorClass, [ doorToObj ]);
// may be tricky
//          link.init();
      link.id += 'Link';
      if (linkedName != null)
        link.name = linkedName;
      if (linkedNames != null)
        link.names = linkedNames;
      link.doorDir = Const.compassDirectionReverse[doorDir];
      link.doorTo = parent.id;
      link.doorToObj = parent;
      link.linkedObj = this;
      // set reverse xTo and xToObj in link parent
      for (dir in Const.compassPropsReverse.keys())
        {
          // find dir
          var obj = Reflect.field(parent, dir + 'ToObj');
          if (obj != this)
            continue;
          // set up reverse
          var reverse = Const.compassPropsReverse[dir];
          Reflect.setField(link.parent,
            reverse + 'ToObj', link);
          Reflect.setField(link.parent,
            reverse + 'To', link.id);
          // set link parent dirObj
          link.parent.asRoom().dirObj[link.doorDir] = link;
        }
      doorToObj.addChild(link);
      linkedObj = link;
    }
}
