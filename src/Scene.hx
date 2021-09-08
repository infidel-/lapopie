// scene dynamic state

class Scene
{
  public var game: Game;
  public var console: Console;
  public var locations: Array<Location>;
  public var events: Array<Event>;
  public var startingLocation: Location;

  public function new(g: Game)
    {
      game = g;
      locations = [];
      events = [];
      console = game.console;
    }

// scene events turn
  public function turn()
    {
      for (e in events)
        if (e.isEnabled)
          {
            var ret = e.turn();
            if (ret == EVENT_STOP)
              e.isEnabled = false;
          }
    }

// enter scene
  public function enter()
    {
      // init scene locations default values
      for (l in locations)
        for (o in l.objects)
          {
            if (o.state == null)
              o.state = 0;
            if (o.isEnabled == null)
              o.isEnabled = true;
          }

      game.location = this.startingLocation;
      game.state = STATE_LOCATION;
      game.location.print();
    }

// move to location by id
  public function moveTo(id: String)
    {
      if (game.isOver)
        return;

      for (l in locations)
        if (l.id == id)
          {
            game.location = l;
            game.location.print();
            return;
          }
    }

// move player to a given location in the scene
  public function move(id: String)
    {
      var newloc = null;
      for (loc in locations)
        if (loc.id == id)
          {
            newloc = loc;
            break;
          }
      if (newloc == null)
        {
          game.console.error('No such location: ' + id + '.');
          return;
        }

      game.location = newloc;
      game.location.print();
    }

  inline function print(s: String)
    {
      game.console.print(s);
    }

  inline function printFail(id: String)
    {
      game.console.printFail(id);
    }

  inline function printString(id: String)
    {
      game.console.printString(id);
    }
}
