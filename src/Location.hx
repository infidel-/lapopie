// scene location info

@:structInit class Location
{
  public var id: String;
  public var game: Game;
  public var name: String;
  public var note: String;
  public var actions: Array<LocationActionInfo>;
  public var objects: Map<String, ObjectInfo>;

  public function new(id: String,
      game: Game,
      name: String,
      note: String,
      actions: Array<LocationActionInfo>,
      objects: Map<String, ObjectInfo>)
    {
      this.id = id;
      this.game = game;
      this.name = name;
      this.note = note;
      this.actions = actions;
      this.objects = objects;
    }


// runs a special location command if found
// 0 - no such command
// 1 - command found
  public function runSpecialCommand(cmd: String): Int
    {
      // special location commands check
      for (a in actions)
        if (Lambda.has(a.names, cmd))
          {
            if (a.func != null)
              a.func();
            return 1;
          }

      return 0;
    }

// runs a console command on this location
// 0 - error, show standard error message
// 1 - success
// -1 - error, skip standard error message
  public function runCommand(cmd: String, tokens: Array<String>): Int
    {
      // we need at least 2 tokens: command and object
      if (tokens.length < 1)
        return 0;

      // roll X on Y
      var obj = null;
      var action = null;
/*
      if (cmd == 'roll' || cmd == 'r')
        {
          // find skill
          var skillInfo = SkillConst.getInfo(tokens[0]);
          if (skillInfo == null || skillInfo.isFake)
            return 0;

          var skill = game.player.skills[skillInfo.id];
          if (skill.val == 0)
            {
              game.console.print('You do not have that skill.');
              return -1;
            }

          // find enabled object with this name
          obj = game.scene.getEnabledObject(tokens[1]);
          if (obj == null || obj.actions == null)
            return 0;

          // check if this object has this skill attached
          action = null;
          for (a in obj.actions)
            if (a.roll == skillInfo.id)
              {
                action = a;
                break;
              }
        }
      
      else
*/
        {
          // find enabled object with this name
          obj = game.location.getEnabledObject(tokens[0]);
          if (obj == null)
            return 0;

          // handle simple actions
          if (obj.simpleActions != null && obj.simpleActions[cmd] != null)
            {
              game.console.print(obj.simpleActions[cmd]);
              return 1;
            }

          // check if this object has this action
          if (obj.actions != null)
            {
              for (a in obj.actions)
                if (Lambda.has(a.names, cmd))
                  {
                    action = a;
                    break;
                  }
            }
        }

      // no such action, print fail string if it exists
      if (action == null)
        {
          var ret = game.console.printFail(cmd);
          if (ret)
            return -1;
          return 0;
        }

/*
      // re-check for associated skill
      if (action.roll != null)
        {
          var skill = game.player.skills[action.roll];
          if (skill.val == 0)
            {
              game.console.print('You do not have that skill.');
              return -1;
            }
        }
*/

      // already did this action
      if (action.onlyOnce && action.isEnabled == false)
        {
          game.console.print('You have already tried that.');
          return -1;
        }

      // run action code
      if (action.note != null)
        game.console.print(action.note);
      if (action.func != null)
        action.func(obj);
      if (action.onlyOnce)
        action.isEnabled = false;
      if (action.result != null)
        return handleActionResult(action.result);

      return 1;
    }


// helper: handle action result
  public function handleActionResult(result: ActionResultInfo): Int
    {
/*
      // start a new chat
      if (result.type == RESULT_CHAT)
        {
          var npc = game.scene.getNPC(result.info);
          if (npc == null)
            {
              game.console.error('No such NPC found: ' + result.info + '.');
              return -1;
            }

          return npc.startChat();
        }

      // finish chat: success
      else if (result.type == RESULT_CHAT_FINISH_SUCCESS)
        {
          game.npc.finishChat(true);
        }

      else */game.console.error('No result handler for ' + result);
      return 1;
    }

// print location info
  public function print()
    {
      game.console.print('**' + name + '**\n' + note);
      var s = new StringBuf();
      for (o in objects)
        if (o.isEnabled && o.locationNote != null)
          {
            s.add(o.locationNote);
            s.add(' ');
          }
      if (s.length > 0)
        game.console.print(s.toString());
    }

// get object info by its name
  public function getEnabledObject(name: String): ObjectInfo
    {
      for (o in objects)
        if (o.isEnabled && Lambda.has(o.names, name))
          return o;
      return null;
    }


  public static var commandHelp = [
    'examine' => 'examine, x, look, l <object> - Examines the given object. If no object is given, describes the scene.',
    'look' => 'examine, x, look, l <object> - Examines the given object. If no object is given, describes the scene.',
    'roll' => 'roll, r <skill> on <object> - Roll a skill on a given object.',
  ];
}
