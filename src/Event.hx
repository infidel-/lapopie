// scene event info

class Event
{
  public var id: String;
  public var game: Game;
  public var name: String;
  public var isEnabled: Bool;
  public var state: Int;

  public function new(game: Game)
    {
      this.id =  '?';
      this.game = game;
      this.name = '?';
      this.isEnabled = true;
      this.state = 0;
    }

  public inline function print(s)
    {
      game.console.print(s);
    }

// DYNAMIC
  public function turn(): _EventResult { return EVENT_CONTINUE; }
}
