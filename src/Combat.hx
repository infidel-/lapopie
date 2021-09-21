// combat manager, opponents are cleared on exit

class Combat
{
  var game: Game;
  public var opponents: Array<CombatOpponent>;
  public var player: CombatOpponent;
  public var round: Int;
  public var logRound: String; // actions log for each turn
  public var logSegment: Int; // last log segment

  public function new(g: Game)
    {
      game = g;
      opponents = [];
      round = 1;
      logRound = '';
      logSegment = 0;
    }

// add a group of monsters into combat
  public function addMonsterGroup(monsters: Array<String>, distance: Int)
    {
      var maxGroup = getMaxGroup();

      for (monsterID in monsters)
        {
          var m = _MonstersTable.list[monsterID];
          if (m == null)
            throw 'no such monster: ' + monsterID;

          var op = new CombatOpponent(game);
          op.type = COMBAT_MONSTER;
          op.monster = m;
          var letter = getMonsterLetter(monsterID);
          op.name = op.monster.name + ' ' + letter;
          op.nameCapped = op.monster.nameCapped + ' ' + letter;
          op.group = maxGroup + 1;
          op.x = distance;
          op.isEnemy = true;
          op.init();
          opponents.push(op);
        }
    }

// helper: find next unique monster letter of a given type
  public function getMonsterLetter(monsterID: String): String
    {
      var cnt = 0;
      for (op in opponents)
        if (op.type == COMBAT_MONSTER && op.monster.id == monsterID)
          cnt++;
      return String.fromCharCode(65 + cnt);
    }

// helper: get max group on the field
  public function getMaxGroup(): Int
    {
      // get max group
      var maxGroup = 0;
      for (op in opponents)
        if (op.group > maxGroup)
          maxGroup = op.group;
      return maxGroup;
    }

// helper: get min free group on the field
  public function getMinFreeGroup(): Int
    {
      // get max group
      var maxGroup = getMaxGroup();
      for (group in 0...maxGroup)
        if (getGroupMembers(group) == 0)
          return group;
      return maxGroup + 1;
    }

// helper: get group members count
  public function getGroupMembers(group: Int): Int
    {
      var cnt = 0;
      for (op in opponents)
        if (op.group == group && !op.isDead)
          cnt++;
      return cnt;
    }

// helper: get opposing side members count in a group
  public function getGroupEnemies(group: Int, isEnemy: Bool): Int
    {
      var cnt = 0;
      for (op in opponents)
        if (op.group == group && op.isEnemy != isEnemy && !op.isDead)
          cnt++;
      return cnt;
    }


// helper: get first group opponent
  public function getFirstGroupOpponent(group: Int): CombatOpponent
    {
      for (op in opponents)
        if (op.group == group)
          return op;
      return null;
    }

// start combat with current opponents
  public function start()
    {
      p('**COMBAT BEGINS**');
      // add party members (in front)
      for (i in 0...game.party.length)
        {
          var char = game.party[game.party.length - i - 1];
          var op = new CombatOpponent(game);
          op.type = COMBAT_PARTY_MEMBER;
          op.nameCapped = char.nameCapped;
          op.name = char.name;
          op.isEnemy = false;
          op.character = char;
          op.group = 0;
          op.x = 0;
          op.init();
          opponents.insert(0, op);
          if (char.isPlayer)
            {
              player = op;
              op.isPlayer = true;
            }
        }

      game.state = STATE_COMBAT;
      print();
    }

// print combat state
  public function print()
    {
      // print all groups
      var maxGroup = getMaxGroup();
      p('Round ' + round);
      for (group in 0...maxGroup + 1)
        {
          // find group x for 
          var op = getFirstGroupOpponent(group);
          if (op == null)
            continue;
          var distance = player.x - op.x;
          if (distance < 0)
            distance = - distance;
          var s = 'Group ' + String.fromCharCode(65 + group) +
            (distance > 0 ? ' (' + distance + "')" : '') + ':\n';
          for (op in opponents)
            {
              if (op.group != group)
                continue;

              s += op.print();
            }
          p(s);
        }
    }

// handle console commands
// 0 - error, show standard error message
// 1 - success
// -1 - error, skip standard error message
  public function runCommand(cmd: String, tokens: Array<String>,
      tokensFull: Array<String>): Int
    {
      // wait
      if (cmd == 'wait')
        {
          player.declaredAction = ACTION_WAIT;
        }

      else if (cmd == 'examine')
        {
          if (tokens.length == 0)
            {
              p('You are currently in combat.');
              return 1;
            }

          // try inventory
          if (game.player.inventory.examine(tokens) == 1)
            return 1;
          else
            {
              p('I do not know what that is.');
              return -1;
            }
        }

      // attack
      else if (cmd == 'attack')
        {
          if (getGroupEnemies(player.group, player.isEnemy) == 0)
            {
              p('There are no enemies close to you.');
              return -1;
            }
          if (player.character.weapon.weapon.type != WEAPONTYPE_MELEE &&
              player.character.weapon.weapon.type != WEAPONTYPE_BOTH)
            {
              p('You don\'t have a melee weapon drawn.');
              return -1;
            }
          player.declaredAction = ACTION_ATTACK;
        }

      // charge
      else if (cmd == 'charge')
        {
          if (tokens.length == 0 || tokens[0].length > 1)
            {
              p('Usage: charge &lt;group letter&gt;');
              return -1;
            }

          var group = Const.letterToNum(tokens[0]);
          if (player.group == group)
            {
              p('You are in that group.');
              return -1;
            }
          if (getGroupMembers(group) == 0)
            {
              p('No such combat group.');
              return -1;
            }
          if (getGroupEnemies(group, player.isEnemy) == 0)
            {
              p('That group has no opponents.');
              return -1;
            }
          if (getGroupEnemies(player.group, player.isEnemy) > 0)
            {
              p('You are engaged in melee.');
              return -1;
            }
          if (player.distanceToGroup(group) > player.character.move * 2)
            {
              p('That group is too far away.');
              return -1;
            }
          if (round - player.lastChargeRound < 10)
            {
              p('You have to wait ' +
                (10 - round + player.lastChargeRound) + ' more rounds before charging.');
              return -1;
            }
          if (player.character.weapon.weapon.type != WEAPONTYPE_MELEE &&
              player.character.weapon.weapon.type != WEAPONTYPE_BOTH)
            {
              p('You cannot charge without a melee weapon drawn.');
              return -1;
            }
          player.declaredAction = ACTION_CHARGE;
          player.targetID = group;
        }

      // draw
      else if (cmd == 'draw')
        {
          if (tokens.length == 0 || tokens[0].length > 1)
            {
              player.character.inventory.print(ITEM_WEAPON);
              p('Usage: draw &lt;item letter&gt;');
              return -1;
            }

          var itemIndex = Const.letterToNum(tokens[0]);
          var item = player.character.inventory.get(ITEM_WEAPON, itemIndex);
          if (item == null)
            {
              p('There is no such item in your inventory.');
              return -1;
            }
          player.declaredAction = ACTION_DRAW;
          player.targetID = item.id;
        }

      // drink
      else if (cmd == 'drink')
        {
          if (tokens.length == 0 || tokens[0].length > 1)
            {
              player.character.inventory.print(ITEM_POTION);
              p('Usage: drink &lt;item letter&gt; [&lt;full|dose&gt;]');
              return -1;
            }

          var itemIndex = Const.letterToNum(tokens[0]);
          var item = player.character.inventory.get(ITEM_POTION, itemIndex);
          if (item == null)
            {
              p('There is no such item in your inventory.');
              return -1;
            }
          var dose = 1;
          if (tokens.length > 1)
            {
              var key = tokens[1];
              var am = [
                'full' => 1,
                'dose' => 2,
              ];
              dose = am[key];
              if (am[key] == null)
                {
                  var doses = '';
                  if (item.potion.doses == 1)
                    doses = 'full';
                  else if (item.potion.doses > 1)
                    doses = 'full, dose';
                  p('Doses accepted: ' + doses + '.');
                  return -1;
                }
            }
          if (dose == 1 && item.potion.doses > 1 &&
              item.potionDoses < item.potion.doses)
            dose = 2;
          if (getGroupEnemies(player.group, player.isEnemy) > 0)
            {
              p('You cannot drink potions while engaging in melee combat.');
              return -1;
            }
          var ret = item.potion.canDrink(player.character);
          if (!ret.result)
            {
              p(ret.msg);
              return -1;
            }

          player.declaredAction = ACTION_DRINK;
          player.targetID = item.id;
          player.drinkDose = dose;
        }

      // retreat
      else if (cmd == 'retreat')
        {
          if (getGroupEnemies(player.group, player.isEnemy) == 0)
            {
              p('You are not in a melee.');
              return -1;
            }
          player.isParrying = true;
          player.declaredAction = ACTION_RETREAT;
        }

      // parry
      else if (cmd == 'parry')
        {
          if (player.character.weapon.weapon.id == 'unarmed')
            {
              p('You cannot parry without a melee weapon.');
              return -1;
            }
          player.isParrying = true;
          player.declaredAction = ACTION_PARRY;
        }

      // move
      else if (cmd == 'move')
        {
          if (tokens.length == 0 || tokens[0].length > 1)
            {
              p('Usage: move|close &lt;group letter&gt;');
              return -1;
            }

          var group = tokens[0].charCodeAt(0);
          // A-Z
          if (group >= 65 && group <= 90)
            group -= 65;
          // a-z
          else if (group >= 97 && group <= 122)
            group -= 97;
          if (player.group == group)
            {
              p('You are in that group.');
              return -1;
            }
          if (getGroupMembers(group) == 0)
            {
              p('No such combat group.');
              return -1;
            }
          player.declaredAction = ACTION_MOVE;
          player.targetID = group;
        }

      // shoot
      else if (cmd == 'shoot')
        {
          if (tokens.length == 0 || tokens[0].length > 1)
            {
              p('Usage: shoot &lt;group letter&gt;');
              return -1;
            }

          var group = Const.letterToNum(tokens[0]);
          if (player.group == group)
            {
              p('You are in that group.');
              return -1;
            }
          if (getGroupMembers(group) == 0)
            {
              p('No such combat group.');
              return -1;
            }
          if (getGroupEnemies(group, player.isEnemy) == 0)
            {
              p('That group has no opponents.');
              return -1;
            }
          if (getGroupEnemies(player.group, player.isEnemy) > 0)
            {
              p('You are engaged in melee.');
              return -1;
            }
          if (player.character.weapon.weapon.type != WEAPONTYPE_RANGED &&
              player.character.weapon.weapon.type != WEAPONTYPE_BOTH)
            {
              p('You cannot shoot without a ranged weapon drawn.');
              return -1;
            }
          if (player.distanceToGroup(group) > player.character.weapon.weapon.range * 4)
            {
              p('That group is too far away.');
              return -1;
            }
          player.declaredAction = ACTION_SHOOT;
          player.targetID = group;
        }

      else return 0;

      // combat time passing
      turn();
      return 1;
    }

// combat round passing
  function turn()
    {
      // AI declarations
      for (op in opponents)
        {
          if (op.isPlayer || op.isDead)
            continue;
          op.aiDeclareAction();
        }

      // roll initiative
      var playerRoll = Const.dice(1, 6);
      var enemyRoll = Const.dice(1, 6);
      while (enemyRoll == playerRoll)
        enemyRoll = Const.dice(1, 6);
      // DEBUG: always win initiative
      if (game.debug.initiative)
        {
          playerRoll = 1;
          enemyRoll = 6;
        }
      p('Roll initiative (1d6): player side ' +
        playerRoll + ', enemy side ' + enemyRoll);

      // set order according to initiative with dex mods
      // potions move later in order
      var order = new Map<Int, Array<CombatOpponent>>();
      for (op in opponents)
        if (!op.isDead)
          {
            var segment = (op.isEnemy ? enemyRoll : playerRoll);
            // missile attacks get dex bonuses
            if (op.declaredAction == ACTION_SHOOT &&
                (op.type == COMBAT_PARTY_MEMBER ||
                 op.type == COMBAT_NPC))
              segment -= op.character.dexStats.missileBonusToHit;
            // drink works 1d4+1 segments later this(!) turn
            else if (op.declaredAction == ACTION_DRINK)
              segment += Const.dice(1, 4) + 1;
            if (segment < 1)
              segment = 1;
            if (segment > 10)
              segment = 10;
            var list = order[segment];
            if (list == null)
              {
                list = [];
                order[segment] = list;
              }
            list.push(op);
          }

      // resolution
      logRound = '';
      logSegment = 0;
      for (segment in 1...11)
        {
          var list = order[segment];
          if (list == null)
            continue;
          for (op in list)
            if (!op.isDead)
              op.resolveAction(segment);
        }
      p(logRound);
      round++;

      // clear opponent state
      for (op in opponents)
        op.clear();
      print();
      checkFinish();
    }

// check for combat finish
  function checkFinish()
    {
      // game over
      if (player.isDead)
        {
          game.finish('loseHP');
          return;
        }
      // opponents dead, combat over
      for (op in opponents)
        if (op.isEnemy && !op.isDead)
          return;
      p('The battle is over. You are victorious.');
      game.console.printNarrative('Your first test is over, but many more await you in the future. Thank you for playing!');
      game.state = STATE_LOCATION;
    }

// get commands list for help command
  public function getCommandList(): String
    {
      var s = 'Combat commands: ';
      for (c in commands)
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

  inline function p(s: String)
    {
      game.console.print(s);
    }

// get command info
  public static function getCommandInfo(cmds: String): _CombatCommand
    {
      // find command
      var cmd = null;
      for (c in commands)
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
  public static function getCommandHelp(cmds: String): String
    {
      // find command
      var cmd = getCommandInfo(cmds);
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

  public static var commands: Array<_CombatCommand> = [
    {
      id: 'attack',
      variants: [ 'attack', 'a' ],
      help: 'Declare that the player character wants to attack with a melee weapon.',
    },
    {
      id: 'charge',
      args: '<group letter>',
      variants: [ 'charge', 'ch' ],
      help: 'Declare that the player character wants to charge into a given combat group.',
    },
    {
      id: 'draw',
      variants: [ 'draw', 'd' ],
      args: '<item letter>',
      help: 'Declare that the player character wants to draw another weapon from the inventory. Shows a list of weapons without arguments.',
    },
    {
      id: 'drink',
      variants: [ 'drink', 'quaff', 'q' ],
      args: '<item letter> [<full|half|third>]',
      help: 'Declare that the player character wants to quaff a potion from the inventory in full or partially if possible. Shows a list of potions without arguments.',
    },
    {
      id: 'examine',
      variants: [ 'examine', 'x', 'look at', 'look', 'l' ],
      args: '<item>',
      help: 'Examine an item in player inventory. For the sake of convenience this action does not take time.',
    },
    {
      id: 'move',
      variants: [ 'move', 'm', 'close', 'cl' ],
      args: '<group letter>',
      help: 'Declare that the player character wants to close distance to a given combat group.',
    },
    {
      id: 'parry',
      variants: [ 'parry', 'p' ],
      help: 'Declare that the player character wants to parry for this round.',
    },
    {
      id: 'retreat',
      variants: [ 'retreat', 'r' ],
      help: 'Declare that the player character wants to retreat from the current combat group. Parrying is enabled while retreating.',
    },
    {
      id: 'shoot',
      args: '<group letter>',
      variants: [ 'shoot', 's' ],
      help: 'Declare that the player character wants to shoot into a given combat group.',
    },
    {
      id: 'wait',
      variants: [ 'wait', 'z' ],
      help: 'Declare that the player character waits for one round.',
    },
  ];
}

typedef _CombatCommand = {
  var id: String;
  var variants: Array<String>;
  @:optional var args: String;
  var help: String;
}
