// console functionality (excluding platform-specific UI)

class Console
{
  var game: Game;
  var _console: _Console;
  public var lastCommand: String;

  public function new(g: Game)
    {
      game = g;
      _console = new _Console(game);
      lastCommand = '';
    }


// run console command (called from platform-specific UI)
// 0 - error, show standard error message
// 1 - success
// -1 - error, skip standard error message
  public function runCommand(str: String): Int
    {
      // split command into tokens
      var tmp = str.split(' ');
      var tokens = [];
      var tokensFull = [];
      var ignored = Const.ignoredKeywords;
      if (game.state == STATE_COMBAT)
        ignored = Const.ignoredCombatKeywords;
      for (x in tmp)
        {
          if (!Lambda.has(ignored, x))
            tokens.push(x.toLowerCase());
          tokensFull.push(x.toLowerCase());
        }
//      trace(tokens);
      lastCommand = tokensFull.join(' ');

      var cmd = tokens.shift();
      tokensFull.shift();

      // try common commands first
      var ret = runCommandCommon(cmd, tokens);
      if (ret != 0)
        {
          runCommandPost();
          return ret;
        }
      if (game.isOver)
        {
          print('Game over, please start a new one.');
          return -1;
        }

      // state-specific commands
      if (game.state == STATE_LOCATION)
        {
          var ret = runCommandLocation(cmd, tokens);
          runCommandPost();
          return ret;
        }
      else if (game.state == STATE_COMBAT)
        {
          var info = Combat.getCommandInfo(cmd);
          if (info == null)
            return 0;
          return game.combat.runCommand(info.id, tokens, tokensFull);
        }
/*
      else if (game.state == STATE_CHAT)
        return game.npc.runCommand(cmd, tokens, tokensFull);
*/

      return 0;
    }

// post-run command, move world
  function runCommandPost()
    {
      game.turn();
    }

// common commands
  function runCommandCommon(cmd: String, tokens: Array<String>): Int
    {
      // help
      if (cmd == 'help' || cmd == 'h' || cmd == '?')
        {
          if (tokens.length == 0)
            {
              var s = 'Commonly available commands: ' +
                'again (g), party/stats, who\n';
              if (game.state == STATE_LOCATION)
                s += 'Location commands: ' +
                  'enter, examine (x), exit, go, ' +
                  'look (l), roll (r), talk (t), use (u), wait (z)';
              else if (game.state == STATE_COMBAT)
                s += game.combat.getCommandList();
              system(s);
            }
          else
            {
              var text = commandHelp[tokens[0]];
              if (text == null)
                {
                  if (game.state == STATE_LOCATION)
                    text = Location.commandHelp[tokens[0]];
                  else if (game.state == STATE_COMBAT)
                    text = Combat.getCommandHelp(tokens[0]);
                }
              if (text != null)
                {
                  text = Const.replaceSpecial(text);
                  system(text);
                }
              else system('There is no such command or no help available.');
            }
          return 1;
        }

      // repeat last command
      else if (cmd == 'again' || cmd == 'g')
        {
          // do not store repeat itself
          _console.removeLast();

          var command = _console.getLast();
          if (command != null)
            return runCommand(command);
        }

#if mydebug
      else if (cmd == 'debug' || cmd == 'dbg')
        return runDebugCommand(tokens);
#end

      // party/stats
      else if (cmd == 'party' || cmd == 'stats')
        {
          for (ch in game.party)
            {
              var s = ch.print();
              print(s);
            }
          return 1;
        }

/*
      // who
      else if (cmd == 'who')
        {
          // list known characters
          if (tokens.length < 1)
            {
              var s = new StringBuf();
              s.add('Known characters: ');
              for (ch in game.adventure.info.who)
                if (ch.isKnown)
                  s.add(ch.name + ', ');
              var msg = s.toString();
              msg = msg.substr(0, msg.length - 2);
              print(msg);
              return 1;
            }

          // check if char is known
          var name = tokens[0];
          var char = null;
          for (ch in game.adventure.info.who)
            if (ch.isKnown && Lambda.has(ch.names, name))
              {
                char = ch;
                break;
              }
          if (char == null)
            {
              system('I have no idea who that is.');
              return 1;
            }
          print(char.note);

          return 1;
        }
*/

      return 0;
    }


// location commands
  function runCommandLocation(cmd: String, tokens: Array<String>): Int
    {
      // check for special location commands
      var ret = game.location.runSpecialCommand(lastCommand);
      if (ret == 1)
        return ret;

      // hack: replace pick up -> get
      if (cmd == 'pick' && tokens[0] == 'up')
        {
          cmd = 'get';
          tokens.shift();
        }

      // look/examine
      if (Lambda.has([ 'look', 'l', 'examine', 'x' ], cmd))
        {
          // examine location
          if (tokens.length < 1)
            {
              game.location.print();
              return 1;
            }

          // find referenced object
          var obj = game.location.getEnabledObject(tokens[0]);
          if (obj == null)
            {
              system("I did not understand what that referred to.");
              return -1;
            }

          // examine note
          if (obj.note != null)
            print(obj.note);

          // examine action with function attached
          // replace examine/x/look/l with single command
          else return game.location.runCommand('x', tokens);

          return 1;
        }

      // wait
      else if (cmd == 'wait' || cmd == 'z')
        {
          print('Time passes...');
          return 1;
        }

      // location-specific commands
      else return game.location.runCommand(cmd, tokens);

      return 0;
    }


#if mydebug
// debug command
  function runDebugCommand(tokens: Array<String>): Int
    {
/*
      if (tokens.length == 0)
        {
          system('Debug commands:\n' +
            'anxiety (a) - set anxiety in chat\n' +
            'eval (e) - toggle always on evaluate timer\n' +
            'hp [val] - set player hp\n' +
            'fail (f) - fail next roll\n' +
            'rapport (r) - set rapport in chat\n' +
            'skill (sk) [id/name] [val] - set skill value'
          );
          return 1;
        }
      var cmd = tokens[0];

      // set chat anxiety
      if (cmd == 'anxiety' || cmd == 'a')
        {
          if (game.state != STATE_CHAT)
            {
              system('Not in chat.');
              return 1;
            }
          var val = Std.parseInt(tokens[1]);
          system('[Anxiety ' + val + ']');
          game.npc.anxiety = val;

          return 1;
        }

      // evaluate timer
      else if (cmd == 'eval' || cmd == 'e')
        {
          game.debug.evaluate = !game.debug.evaluate;
          system('[Evaluate always on: ' + game.debug.evaluate + ']');

          return 1;
        }

      // auto-fail next roll
      else if (cmd == 'fail' || cmd == 'f')
        {
          game.debug.failRoll = true;
          system('[Next roll will fail]');

          return 1;
        }

      // hp <val> - set hp value
      else if (cmd == 'hp')
        {
          var val = Std.parseInt(tokens[1]);
          game.player.hp = val;
          system('[hp set to ' + val + '.]');

          return 1;
        }

      // set chat rapport
      else if (cmd == 'rapport' || cmd == 'r')
        {
          if (game.state != STATE_CHAT)
            {
              system('Not in chat.');
              return 1;
            }
          var val = Std.parseInt(tokens[1]);
          system('[Rapport ' + val + ']');
          game.npc.rapport = val;

          return 1;
        }

      // debug skill <id/name> <val> - set skill value
      else if (cmd == 'skill' || cmd == 'sk')
        {
          var id = tokens[1];
          var val = Std.parseInt(tokens[2]);
          var skill = SkillConst.getInfo(id);
          if (skill == null)
            {
              system('No such skill.');
              return 0;
            }
          var playerSkill = game.player.skills[skill.id];
          playerSkill.val = val;
          system('[Skill ' + skill.name + ' set to ' + val + '.]');

          return 1;
        }
*/

      return 0;
    }
#end


// print string
  public inline function print(s: String)
    {
      _console.print(s);
    }

// print narrative string
  public inline function printNarrative(s: String)
    {
      _console.print('<span class=narrative>' + s + '</span>');
    }

// print debug string
  public inline function debug(s: String)
    {
      _console.debug(s);
    }


// print error string
  public inline function error(s: String)
    {
      _console.error(s);
    }


// print system string
  public inline function system(s: String)
    {
      _console.print('<span class=consoleSys>' + s + '</span>');
    }


  public inline function printFail(id: String): Bool
    {
      if (Const.stringsFail[id] != null)
        {
          print(
            Const.stringsFail[id][Std.random(
              Const.stringsFail[id].length)]);
          return true;
        }
      return false;
    }


  public inline function printString(id: String)
    {
      print(
        Const.stringsFail[id][Std.random(Const.strings[id].length)]);
    }


// clear console
  public inline function clear()
    {
      _console.clear();
    }


  static var commandHelp = [
    'again' => 'again, g - Repeats previous command again.',
    'examine' => 'examine, x, look, l <object> - Examines the given object.',
    'look' => 'examine, x, look, l <object> - Examines the given object.',
    'party' => 'party, stats - Prints party information.',
    'stats' => 'stats, party - Prints party information.',
    'who' => 'who <name> - Prints information about a non-player character. If the name is not given, lists known characters.',
  ];
}
