// scene -> room
class Room extends Obj
{
/**
_String or routine_   `"You can't go that way."`

_For rooms_   Message, or routine to print one, when a player tries to go in an impossible direction from this room.  
_No return value_
**/
  public var cantGo: String;

  public function new(parent: Obj)
    {
      super(parent);
      type = 'room';
      dirObj = new Map();
    }

  override function during()
    {
      switch (action)
        {
          case GODIR:
            var obj = dirObj[dir];
            if (obj == null)
              {
                debug('CANTGO ERROR');
                return;
              }
            game.party.moveTo(obj);
          default:
            super.during();
        }
    }

// room actions
  override function after()
    {
      switch (action)
        {
          // room description
          case LOOK:
            return descRoom(true);
          case GODIR:
            return '';
          default:
            return super.after();
        }
      return '';
    }

  override function initialF(): String
    {
      return descRoom(false);
    }

// room description, full or brief
  public function descRoom(forceFull: Bool)
    {
      var s = '**' + name + '**\n';
      // mark room as visited on first "look"
      if (!hasAttr(VISITED))
        {
          s += desc;
          setAttr(VISITED);
        }
      else if (forceFull)
        s += desc;
      for (ch in children)
        if (!ch.hasAttr(CONCEALED))
          {
            // initial description
            if (!ch.hasAttr(STATIC) &&
                !ch.hasAttr(MOVED))
              {
                var tmp = ch.initialF();
                if (tmp != null && tmp != '')
                  s += '\n' + tmp;
                else if (ch.initial != null &&
                    ch.initial != '')
                  s += '\n' + ch.initial;
              }
            else s += '\n' + ch.describeF();
          }
      return s;
    }

  public override function init()
    {
      super.init();

      // find all direction objects for quicker access
      for (f in Const.compassDirectionProps.keys())
        dirObj[Const.compassDirectionProps[f]] =
          stringToObject(f + 'To');
    }

/**
_Room, object or routine_
_For rooms_   These twelve properties (there are also `ne_to`, `nw_to`, `se_to`, `sw_to`, `in_to`, `out_to`, `u_to` and `d_to`) are the map connections for the room. A value of 0 means “can't go this way”. Otherwise, the value should either be a room or a `door` object: thus, `e_to` might be set to `crystal_bridge` if the direction “east” means “over the crystal bridge”.  
_Routine returns_   The room or object the map connects to; or 0 for “can't go this way”; or 1 for “can't go this way; stop and print nothing further”.  
_Warning_   Do not confuse the direction properties `n_to` and so on with the twelve direction objects, `n_obj` et al.
**/
  // string versions
  public var nTo: String;
  public var sTo: String;
  public var wTo: String;
  public var eTo: String;
  public var nwTo: String;
  public var neTo: String;
  public var swTo: String;
  public var seTo: String;
  public var uTo: String;
  public var dTo: String;
  // object versions
  public var nToObj: Obj;
  public var sToObj: Obj;
  public var wToObj: Obj;
  public var eToObj: Obj;
  public var nwToObj: Obj;
  public var neToObj: Obj;
  public var swToObj: Obj;
  public var seToObj: Obj;
  public var uToObj: Obj;
  public var dToObj: Obj;
  // map
  public var dirObj: Map<_CompassDirection, Obj>;
}
