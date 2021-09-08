// combat opponent - player, party member, monster or NPC

class CombatOpponent
{
  var game: Game;
  var combat: Combat;

  // type and type-dependent vars
  public var type: _CombatOpponentType;
  public var character: Character;
  public var monster: _Monster;
  public var isPlayer: Bool;
  public var isEnemy: Bool;
  public var isDead: Bool;
  public var declaredAction: _CombatAction;
  public var targetGroup: Int;

  // common vars
  public var name: String;
  public var nameCapped: String;
  public var hp: Int;
  public var maxHP: Int;
  public var group: Int;
  public var distance: Int;

  public function new(g: Game)
    {
      game = g;
      combat = game.combat;
      name = '?';
      nameCapped = '?';
      hp = 0;
      maxHP = 0;
      group = 0;
      distance = 0;
      declaredAction = ACTION_WAIT;
      targetGroup = 0;
      isPlayer = false;
      isEnemy = false;
      isDead = false;
    }

// init opponent vars
  public function init()
    {
      if (type == COMBAT_MONSTER)
        {
          hp = maxHP = Const.dice(monster.hitDice[0], monster.hitDice[1]) +
            monster.hitDice[2];
        }
      else if (type == COMBAT_PARTY_MEMBER)
        {
          hp = character.hp;
          maxHP = character.maxHP;
        }
    }

// calculate distance to a given opponent
// NOTE: all opponents are points on a virtual line to player, where
// the player is in zero
  public function distanceToOpponent(op: CombatOpponent): Int
    {
      var dst = op.distance - distance;
      if (dst < 0)
        dst = - dst;
      return dst;
    }

// calculate distance to a given group
// NOTE: all opponents are points on a virtual line to player, where
// the player is in zero
  public function distanceToGroup(group: Int): Int
    {
      var op = combat.getFirstGroupOpponent(group);
      var dst = op.distance - distance;
      if (dst < 0)
        dst = - dst;
      return dst;
    }

// AI: declare action for this round
  public function aiDeclareAction()
    {
      // find closest group
      var tgt = null;
      var dst = 10000;
      for (op in combat.opponents)
        {
          if (op.isEnemy == isEnemy || op.isDead)
            continue;

          // all opponents are points on a virtual line to player
          var opdst = distanceToOpponent(op);
          if (opdst > dst)
            continue;

          dst = opdst;
          tgt = op;
        }
      // weird, no target found
      if (tgt == null)
        {
          declaredAction = ACTION_WAIT;
          return;
        }
      
      targetGroup = tgt.group;
      if (distanceToOpponent(tgt) <= 10)
        declaredAction = ACTION_ATTACK;
      else declaredAction = ACTION_MOVE;
    }

// opponent action resolution
  public function resolveAction(segment: Int)
    {
      // move action
      if (declaredAction == ACTION_MOVE)
        actionMove(segment);
      else if (declaredAction == ACTION_WAIT)
        {
          log(segment, nameCapped + ' cautiously wait' +
            (isPlayer ? '' : 's') + '.');
        }
      else if (declaredAction == ACTION_ATTACK)
        actionAttack(segment);
      
      declaredAction = ACTION_WAIT;
    }

// move opponent to target
  function actionMove(segment: Int)
    {
      var move = 0;
      if (type == COMBAT_MONSTER)
        move = monster.move;
      else if (type == COMBAT_PARTY_MEMBER || type == COMBAT_NPC)
        move = character.move;

      // check if someone from the other side got close already
      var hasEnemyClose = false;
      for (op in combat.opponents)
        if (op.group == group && op.isEnemy != isEnemy && !op.isDead)
          {
            hasEnemyClose = true;
            break;
          }
      if (hasEnemyClose)
        {
          log(segment, nameCapped + ' cautiously wait' +
            (isPlayer ? '' : 's') + '.');
          return;
        }

      var target = combat.getFirstGroupOpponent(targetGroup);
      var dst = distanceToOpponent(target);
      // NOTE: 10' is melee range
      if (dst <= move + 10) // add to target group
        {
          distance = target.distance;
          group = targetGroup;
          move = dst - 10;
          if (move < 0)
            move = 0;
        }
      else
        {
          // separate into new group if not solo already
          if (combat.getGroupMembers(group) > 1)
            group = combat.getMaxGroup() + 1;
          // move to player
          if (target.distance < distance)
            distance -= move;
          // move away from player
          else distance += move;
        }

      var targetStr = ' group ' + String.fromCharCode(65 + targetGroup);
      if (combat.getGroupEnemies(targetGroup, isEnemy) == 1)
        {
          var targetOp = combat.getFirstGroupOpponent(targetGroup);
          targetStr = targetOp.name;
        }
      log(segment, nameCapped + ' close' + (isPlayer ? '' : 's') +
        ' into combat ' +
        (move > 0 ? ' (' + move + '\')' : '') +
        ' with ' + targetStr + '.');
    }

// attack random opponent in the same group
  function actionAttack(segment: Int)
    {
      // get a list of live opponents in the same group
      var targets = [];
      for (op in combat.opponents)
        {
          if (op.group != group || op.isEnemy == isEnemy || op.isDead)
            continue;
          targets.push(op);
        }
      // all opponents are dead already
      if (targets.length == 0)
        {
          log(segment, nameCapped + ' cautiously wait' +
            (isPlayer ? '' : 's') + '.');
          return;
        }

      // pick random target and attack
      var target = targets[Std.random(targets.length)];
      var targetAC = target.getAC();
      if (type == COMBAT_MONSTER)
        {
          var thac = _TablesFighter.instance.thac(monster.level,
            targetAC);
          for (atk in 0...monster.attacks)
            {
              var roll = Const.dice(1, 20);
              var ext = ' [rolls ' + roll + ' vs ' + thac + ' (AC ' +
                targetAC + ')' + ']';
              if (roll < thac)
                {
                  log(segment, nameCapped + ' ' +
                    (isPlayer ? 'try' : 'tries') + ' to attack ' +
                    target.name + ', but miss' +
                    (isPlayer ? '' : 'es') + '.' +
                    (game.extendedInfo ? ext : ''));
                  continue;
                }
              var row = monster.damage[atk];
              var dmg = Const.dice(row[0], row[1]) + row[2];
              if (dmg < 0)
                dmg = 0;
              ext += ' [DMG ' + row[0] + 'd' + row[1] +
                (row[2] > 0 ? '+' + row[2] : '') + 
                (row[2] < 0 ? '' + row[2] : '') + ' = ' + dmg + ']';

              log(segment, nameCapped + ' attack' +
                (isPlayer ? '' : 's') + ' ' +
                target.name + ' for ' + dmg + ' damage.' +
                (game.extendedInfo ? ext : ''));
              target.hp -= dmg;
              if (target.hp <= 0)
                {
                  target.isDead = true;
                  break;
                }
            }
        }

      // character
      else if (type == COMBAT_PARTY_MEMBER || type == COMBAT_NPC)
        {
          var thac = character.classTables.thac(character.level,
            targetAC);
          var roll = Const.dice(1, 20) +
            character.strStats.toHitBonus;
          var ext = ' [rolls ' + roll + ' vs ' + thac + ' (AC ' +
            targetAC + ')';
          if (character.strStats.toHitBonus != 0)
            {
              if (character.strStats.toHitBonus > 0)
                ext += ', +' + character.strStats.toHitBonus;
              else ext += ', ' + character.strStats.toHitBonus;
              ext += ' to hit';
            }
          ext += ']';

          if (roll < thac)
            {
              log(segment, nameCapped + ' ' +
                (isPlayer ? 'try' : 'tries') + ' to attack ' +
                target.name + ', but miss' +
                (isPlayer ? '' : 'es') + '.' +
                (game.extendedInfo ? ext : ''));
              return;
            }
          // TODO vs large
          // NOTE: copy array to apply bonuses
          var row = Reflect.copy(character.meleeWeapon.damageVsMedium);
          row[2] += character.strStats.toDamageBonus;
          var dmg = Const.dice(row[0], row[1]) + row[2];
          if (dmg < 0)
            dmg = 0;
          ext += ' [DMG ' + row[0] + 'd' + row[1] +
            (row[2] > 0 ? '+' + row[2] : '') + 
            (row[2] < 0 ? '' + row[2] : '') +
            ' = ' + dmg + ']';

          log(segment, nameCapped + ' attack' +
            (isPlayer ? '' : 's') + ' ' +
            target.name + ' for ' + dmg + ' damage.' +
            (game.extendedInfo ? ext : ''));
          target.hp -= dmg;
          if (target.hp <= 0)
            target.isDead = true;
        }
    }

// helper: returns current opponent AC
  function getAC(): Int
    {
      if (type == COMBAT_MONSTER)
        return monster.ac;
      else if (type == COMBAT_PARTY_MEMBER || type == COMBAT_NPC)
        return character.ac;
      return 0;
    }

// helper: add line to segment log
  function log(segment: Int, s: String)
    {
      if (combat.logSegment != segment)
        combat.logTurn += 'S' + segment + ':\n';
      combat.logTurn += '&nbsp;&nbsp;' + s + '\n';
      combat.logSegment = segment;
    }

// print opponent info
  public function print(): String
    {
      var s = '&nbsp;&nbsp;';
      if (isDead)
        s += '~~';
      s += nameCapped;
      if (type == COMBAT_MONSTER)
        {
          if (hp > 0)
            {
              var perc = 100.0 * hp / maxHP;
              if (perc < 33 || (hp < maxHP && hp <= 2))
                s += ' <span class=wounded33>(wounded)</span>';
              else if (perc < 66)
                s += ' <span class=wounded66>(wounded)</span>';
              else if (perc < 100)
                s += ' <span class=wounded99>(wounded)</span>';
            }
#if mydebug
          s += ' <span class=consoleDebug>[' + hp + '/' + maxHP + ' hp]</span>';
#end
        }
      else if (type == COMBAT_PARTY_MEMBER)
        {
          s += ' (' + hp + '/' + maxHP + ' hp)';
        }
      if (isDead)
        s += '~~';
      return s + '\n';
    }
}

@:enum
abstract _CombatOpponentType(String) {
  var COMBAT_PARTY_MEMBER = 'COMBAT_PARTY_MEMBER';
  var COMBAT_NPC = 'COMBAT_NPC';
  var COMBAT_MONSTER = 'COMBAT_MONSTER';
}
