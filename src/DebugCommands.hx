// debug commands container

class DebugCommands
{
  var game: Game;

  public function new(g: Game)
    {
      game = g;
    }

  inline function p(s: String)
    {
      game.console.debug(s);
    }

// run current parser state
  public function run()
    {
      var tokens = game.parserState.tokens;
      var firstWord = tokens[1].word;
      var secondWord = tokens[2].word; // can be null

      if (tokens.length == 0)
        {
          p('Available commands: print (p).');
          return;
        }

      if (Lambda.has([ 'move' ], firstWord))
        {
          var room = game.scene.findObject(secondWord);
          if (room == null)
            {
              p('No such object found.');
              return;
            }
          game.party.moveTo(room);
        }

      // print something
      else if (Lambda.has([ 'print', 'p' ], firstWord))
        {
          if (secondWord == null)
            {
              p('Available sub-commands: parent.');
              return;
            }

          if (secondWord == 'parent')
            js.html.Console.log(game.party.parent);
          else if (Lambda.has([ 'player', 'p' ], secondWord))
            js.html.Console.log(game.player);
          else if (Lambda.has([ 'room', 'r' ], secondWord))
            js.html.Console.log(game.player.getRoom());
          else if (Lambda.has([ 'scope', 's' ], secondWord))
            js.html.Console.log(@:privateAccess game.parser.scope);
          else
            {
              p('Unknown sub-command: ' + secondWord);
              return;
            }
          p('Printed.');
        }
    }
}
