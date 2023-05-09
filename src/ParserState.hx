// current state of the parser

import Parser;

class ParserState
{
  var game: Game;
  var parser: Parser;
  public var action: _Action;
  public var actor: Obj;
  public var first: Obj;
  public var second: Obj;
  public var dir: _CompassDirection;
  public var tokens: Array<_VerbToken>;

  public function new(g: Game, p: Parser)
    {
      game = g;
      parser = p;
      clear();
    }

  public function clear()
    {
      actor = null;
      action = null;
      first = null;
      second = null;
      dir = null;
      tokens = null;
    }

  public function toString()
    {
      return 'action: ' + action +
        ', first: ' + first +
        ', second: ' + second +
        ', dir: ' + dir;
//        ', tokens: ' + tokens;
    }
}
