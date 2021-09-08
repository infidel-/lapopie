// combat manager, opponents are cleared on exit

class Combat
{
  var game: Game;
  public var opponents: Array<CombatOpponent>;
  public var player: CombatOpponent;
  public var round: Int;
  public var logTurn: String; // actions log for each turn
  public var logSegment: Int; // last log segment

  public function new(g: Game)
    {
      game = g;
      opponents = [];
      round = 1;
      logTurn = '';
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
          op.distance = distance;
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

// helper: get group members count
  public function getGroupMembers(group: Int): Int
    {
      var cnt = 0;
      for (op in opponents)
        if (op.group == group)
          cnt++;
      return cnt;
    }

// helper: get opposing side members count in a group
  public function getGroupEnemies(group: Int, isEnemy: Bool): Int
    {
      var cnt = 0;
      for (op in opponents)
        if (op.group == group && op.isEnemy != isEnemy)
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
          op.distance = 0;
          op.init();
          opponents.insert(0, op);
          if (char.isPlayer)
            {
              player = op;
              op.isPlayer = true;
              // TODO: TEST!
              char.move = 40;
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
      game.console.print('Round ' + round);
      for (group in 0...maxGroup + 1)
        {
          var distance = 0;
          for (op in opponents)
            if (op.group == group)
              {
                distance = op.distance;
                break;
              }
          var s = 'Group ' + String.fromCharCode(65 + group) +
            (distance > 0 ? ' (' + distance + "')" : '') + ':\n';
          for (op in opponents)
            {
              if (op.group != group)
                continue;

              s += op.print();
            }
          game.console.print(s);
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
      if (cmd == 'wait' || cmd == 'z')
        {
          player.declaredAction = ACTION_WAIT;
        }

      // move
      else if (cmd == 'move' || cmd == 'close')
        {
          if (tokens.length == 0 || tokens[0].length > 1)
            {
              game.console.print('Usage: move|close &lt;group letter&gt;');
              return -1;
            }

          var group = tokens[0].charCodeAt(0);
          // A-Z
          if (group >= 65 && group <= 90)
            group -= 65;
          // a-z
          else if (group >= 97 && group <= 122)
            group -= 97;
          if (getGroupMembers(group) == 0)
            {
              game.console.print('No such combat group.');
              return -1;
            }
          if (player.group == group)
            {
              game.console.print('You are in that group.');
              return -1;
            }
          player.declaredAction = ACTION_MOVE;
          player.targetGroup = group;
        }

      // attack
      else if (cmd == 'attack' || cmd == 'atk' || cmd == 'a')
        {
          if (getGroupEnemies(player.group, player.isEnemy) == 0)
            {
              game.console.print('There are no enemies close to you.');
              return -1;
            }
          player.declaredAction = ACTION_ATTACK;
        }

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
      game.console.print('Roll initiative (1d6): player side ' +
        playerRoll + ', enemy side ' + enemyRoll);

      // resolution
      logTurn = '';
      logSegment = 0;
      for (segment in 1...11)
        {
          if (segment == playerRoll)
            {
              for (op in opponents)
                if (!op.isEnemy && !op.isDead)
                  op.resolveAction(segment);
            }
          else if (segment == enemyRoll)
            {
              for (op in opponents)
                if (op.isEnemy && !op.isDead)
                  op.resolveAction(segment);
            }
        }
      game.console.print(logTurn);
      round++;

      print();
      // game over
      if (player.isDead)
        game.finish('loseHP');
    }
}
