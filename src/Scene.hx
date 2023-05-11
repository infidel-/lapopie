// world scene - a collection of rooms
class Scene extends Obj
{
// filled during init() to auto-make other sides
// cleaned afterwards
  public var initDoors: Array<Door>;
// dm string, printed on first entry to scene
  public var dm: String;

  public function new(parent: Obj)
    {
      super(parent);
      type = 'scene';
      initDoors = [];
    }

// called when player enters scene
  public function enter()
    {
      // first entry
      if (!hasAttr(VISITED))
        {
          setAttr(VISITED);
          if (dm != null && dm != '')
            game.console.dm(dm);
        }
      // any entry
    }

// fix all string links into object links
  public override function init()
    {
      for (ch in children)
        ch.init();

      // door fixing
      // create a double for each door on the other side
      for (door in initDoors)
        {
          if (door.doorDir == null || door.doorTo == null)
            continue;
          var doorClass = Type.getClass(door);
          var door2 = Type.createInstance(doorClass, [ door.doorToObj ]);
// may be tricky
//          door2.init();
          door2.id += 'Link';
          door2.doorDir = Const.compassDirectionReverse[door.doorDir];
          door2.doorTo = door.parent.id;
          door2.doorToObj = door.parent;
          door2.linkedObj = door;
          for (dir in Const.compassPropsReverse.keys())
            {
              var obj = Reflect.field(door.parent, dir + 'ToObj');
              if (obj != door)
                continue;
              var reverse = Const.compassPropsReverse[dir];
              Reflect.setField(door2.parent,
                reverse + 'ToObj', door2);
              Reflect.setField(door2.parent,
                reverse + 'To', door2.id);
            }
          door.doorToObj.addChild(door2);
          door.linkedObj = door2;
        }
      initDoors = null;
    }

// preprocess action in some cases
  public function preprocessAction(): Bool
    {
      // check for doors in the way
      if (action == GODIR)
        {
          var room = game.party.parent.asRoom();
          var obj = null;
          switch (dir)
            {
              case NORTH:
                obj = room.nToObj;
              case SOUTH:
                obj = room.sToObj;
              case EAST:
                obj = room.eToObj;
              case WEST:
                obj = room.wToObj;
              case NW:
                obj = room.nwToObj;
              case NE:
                obj = room.neToObj;
              case SW:
                obj = room.swToObj;
              case SE:
                obj = room.seToObj;
              case UP:
                obj = room.uToObj;
              case DOWN:
                obj = room.dToObj;
            }
          if (obj == null)
            {
              if (room.cantGo != null &&
                  room.cantGo != '')
                p(room.cantGo);
              else p("You can't go that way.");
              return false;
            }
          else if (obj.type == 'door')
            {
              state.action = ENTER;
              state.first = obj;
            }
          game.console.debug('-> ' +
            game.parserState.toString());
        }
      return true;
    }

// run current parsed action with parameters
  override function during()
    {
      // no nouns: action in current room
      if (first == null)
        {
          var room = actor.getRoom();
          room.runAction();
        }
      else
        {
          first.runAction();
        }
    }

// message after action
  override function after()
    {
      return '';
    }
}
