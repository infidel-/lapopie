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
  public function runCommand(str: String)
    {
      // parse command into tokens and action/objects
      if (!game.parser.run(str))
        return;

      debug('' + game.parser.state);
      var ret = game.scene.preprocessAction();
      if (!ret)
        return;
      game.scene.runAction();
/*
      // character generation commands
      if (game.state == STATE_CHARGEN)
        return game.chargen.runCommand(cmd, tokens);

      // try common commands first
      var info = getCommandInfo(cmd, commonCommands);
      if (info != null)
        {
          var ret = runCommandCommon(info.id, tokens);
          if (ret != 0)
            {
              if (ret > 0)
                runCommandPost();
              return ret;
            }
          if (game.isOver)
            {
              print('Game over, please start a new one.');
              return -1;
            }
        }

      // state-specific commands
      if (game.state == STATE_LOCATION)
        {
          var ret = runCommandLocation(cmd, tokens);
          if (ret == 1)
            runCommandPost();
          return ret;
        }
      else if (game.state == STATE_COMBAT)
        {
          var info = getCommandInfo(cmd, Combat.commands);
          if (info == null)
            return 0;
          return game.combat.runCommand(info.id, tokens, tokensFull);
        }
*/
      return;
    }

// post-run command, move world
// 0 - error, show standard error message
// 1 - success
// -1 - error, skip standard error message
  function runCommandPost()
    {
      game.turn();
    }

// common commands
// 0 - error, show standard error message
// 1 - success
// -1 - error, skip standard error message
  function runCommandCommon(cmd: String, tokens: Array<String>): Int
    {
/*
      // help
      if (cmd == 'help')
        {
          if (tokens.length == 0)
            {
              var s = 
                'Type "help &lt;command&gt;" to read command help.\n' +
                getCommandList('Commonly available commands: ',
                  commonCommands) + '\n';
              if (game.state == STATE_LOCATION)
                s += 'Location commands: ' +
//                  'enter, exit, go, ' +
//                  'roll (r), talk (t), use (u), wait (z)';
                  'wait (z)';
              else if (game.state == STATE_COMBAT)
                s += getCommandList('Combat commands: ', Combat.commands);
              system(s);
            }
          else
            {
              var text = getCommandHelp(tokens[0], commonCommands);
              if (text == null)
                {
                  if (game.state == STATE_LOCATION)
                    text = Location.commandHelp[tokens[0]];
                  else if (game.state == STATE_COMBAT)
                    text = getCommandHelp(tokens[0], Combat.commands);
                }
              if (text != null)
                {
                  text = Const.replaceSpecial(text);
                  system(text);
                }
              else system('There is no such command or no help available.');
            }
          return -1;
        }

      // set/print game options
      else if (cmd == 'options')
        {
          return game.options.runCommand(tokens);
        }

      // repeat last command
      else if (cmd == 'again')
        {
          // do not store repeat itself
          _console.removeLast();

          var command = _console.getLast();
          if (command != null)
            return runCommand(command);
        }

#if mydebug
      else if (cmd == 'debug')
        return runDebugCommand(tokens);
#end

      // inventory
      else if (cmd == 'inventory')
        {
          game.player.inventory.print(null);
          return -1;
        }

      // party stats
      else if (cmd == 'party')
        {
          for (ch in game.party)
            {
              var s = ch.print();
              print(s);
            }
          return 1;
        }
*/

      return 0;
    }


// location commands
// 0 - error, show standard error message
// 1 - success
// -1 - error, skip standard error message
  function runCommandLocation(cmd: String, tokens: Array<String>): Int
    {
/*
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
              // try inventory
              if (game.player.inventory.examine(tokens) == 1)
                return 1;

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

*/
      return 0;
    }


#if mydebug
// debug command
// 0 - error, show standard error message
// 1 - success
// -1 - error, skip standard error message
  function runDebugCommand(tokens: Array<String>): Int
    {
/*
      if (tokens.length == 0)
        {
          system('Debug commands:\n' +
            'init - player side always wins combat initiative'
          );
          return 1;
        }
      var cmd = tokens[0];

      // set chat anxiety
      if (cmd == 'init')
        {
          game.debug.initiative = !game.debug.initiative;
          system('[Player initiative victory: ' + game.debug.initiative + ']');
          return -1;
        }

/*
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

// print DM narrative string
  public inline function dm(s: String)
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
/*
      if (Const.stringsFail[id] != null)
        {
          print(
            Const.stringsFail[id][Std.random(
              Const.stringsFail[id].length)]);
          return true;
        }*/
      return false;
    }


  public inline function printString(id: String)
    {
/*
      print(
        Const.stringsFail[id][Std.random(Const.strings[id].length)]);*/
    }


// clear console
  public inline function clear()
    {
      _console.clear();
    }

/*
// get command info
  public static function getCommandInfo(cmds: String,
      list: Array<_ConsoleCommand>): _ConsoleCommand
    {
      // find command
      var cmd = null;
      for (c in list)
        {
          for (v in c.variants)
            if (cmds == v)
              {
                cmd = c;
                break;
              }
          if (cmd != null)
            break;
        }
      return cmd;
    }

// get command help string
  public static function getCommandHelp(cmds: String,
      list: Array<_ConsoleCommand>): String
    {
      // find command
      var cmd = getCommandInfo(cmds, list);
      if (cmd == null)
        return null;

      // form string
      var s = '';
      for (v in cmd.variants)
        s += v + ', ';
      s = s.substr(0, s.length - 2) +
        (cmd.args != null ? ' ' + cmd.args : '') +
        ' - ' + cmd.help;

      return s;
    }

// get commands list for help command
  public function getCommandList(prefix: String, list: Array<_ConsoleCommand>): String
    {
      var s = prefix;
      for (c in list)
        {
          for (v in 0...c.variants.length)
            {
              if (v == 0)
                s += c.variants[v] + ' (';
              else s += c.variants[v] + ', ';
            }
          s = s.substr(0, s.length - 2) + '), ';
        }
      s = s.substr(0, s.length - 2);
      return s;
    }

  public static var commonCommands: Array<_ConsoleCommand> = [
    {
      id: 'again',
      variants: [ 'again', 'g' ],
      help: 'Repeats previous command again.',
    },
    {
      id: 'examine',
      variants: [ 'examine', 'x', 'look', 'l' ],
      args: '<object>',
      help: 'Examines the given object.',
    },
#if mydebug
    {
      id: 'debug',
      variants: [ 'debug', 'dbg' ],
      args: '<variable>',
      help: 'Debug commands. Run to show full list.',
    },
#end
    {
      id: 'help',
      variants: [ 'help', 'h', '?' ],
      args: '[<command>]',
      help: 'Shows ingame help.',
    },
    {
      id: 'inventory',
      variants: [ 'inventory', 'inv', 'i' ],
      help: 'Shows player inventory.',
    },
    {
      id: 'options',
      variants: [ 'options', 'opts', 'opt', 'settings', 'set' ],
      args: '[<name>] [<value>]',
      help: 'Sets or prints game options.',
    },
    {
      id: 'party',
      variants: [ 'party', 'stats' ],
      help: 'Prints party information.',
    },
  ];*/
}

