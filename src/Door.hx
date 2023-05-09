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
/* - directions
          case ENTER:
            if (!hasAttr(OPEN))
              {
                p("You can't, since " + theName + " is in the way.");
                return false;
              }
          case GO:
            if (!hasAttr(OPEN))
              {
                p("You can't, since " + theName + " is in the way.");
                return false;
              }
*/
          case ENTER:
            if (!hasAttr(OPEN))
              {
                p("You can't, since " + theName + " is closed.");
                return false;
              }
          case GO:
            if (!hasAttr(OPEN))
              {
                p("You can't, since " + theName + " is closed.");
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
          case ENTER:
            game.party.moveTo(doorToObj);
          case GO:
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
          case ENTER:
            return '';
          case GO:
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
}
