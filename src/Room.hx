// scene -> room
class Room extends Obj
{
/**
_String or routine_   `"You can't go that way."`

_For rooms_   Message, or routine to print one, when a player tries to go in an impossible direction from this room.  
_No return value_
**/
  public var cantGo: String;

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

  public function new(parent: Obj)
    {
      super(parent);
      this.type = 'room';
    }

// room actions
  override function after()
    {
      switch (action)
        {
          // room description
          case LOOK:
            return descRoom(true);
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
  function descRoom(forceFull: Bool)
    {
      var s = '**' + name + '**\n';
      if (!hasAttr(VISITED))
        {
          s += desc;
          setAttr(VISITED);
        }
      else if (forceFull)
        s += desc;
      for (ch in children)
        if (!ch.hasAttr(CONCEALED))
          s += '\n' + ch.describeF();
      return s;
    }

  public override function init()
    {
      super.init();

      // find all direction objects for quicker access
      for (f in dirFields)
        stringToObject(f);
    }
  static var dirFields = [ 'nTo', 'sTo', 'wTo', 'eTo', 'nwTo', 'neTo', 'swTo', 'seTo', 'uTo', 'dTo' ];
}
