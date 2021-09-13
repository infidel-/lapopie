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
  public var isParrying: Bool;
  public var wasAttacked: Bool;
  public var declaredAction: _CombatAction;
  public var targetID: Int; // group id, inventory item id
  public var lastChargeRound: Int;

  // common vars
  public var name: String;
  public var nameCapped: String;
  public var hp: Int;
  public var maxHP: Int;
  public var group: Int;
  public var x: Int;

  public function new(g: Game)
    {
      game = g;
      combat = game.combat;
      name = '?';
      nameCapped = '?';
      hp = 0;
      maxHP = 0;
      group = 0;
      x = 0;
      lastChargeRound = -10;
      declaredAction = ACTION_WAIT;
      targetID = 0;
      isPlayer = false;
      isParrying = false;
      isEnemy = false;
      isDead = false;
      wasAttacked = false;
    }

// clear state
  public function clear()
    {
      wasAttacked = false;
      isParrying = false;
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
      var dst = op.x - x;
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
      var dst = op.x - x;
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
      
      targetID = tgt.group;
      if (distanceToOpponent(tgt) <= 10)
        declaredAction = ACTION_ATTACK;
      else
        {
          if (Std.random(100) > 70)
            declaredAction = ACTION_CHARGE;
          else declaredAction = ACTION_MOVE;
        }
    }

// opponent action resolution
  public function resolveAction(segment: Int)
    {
      if (declaredAction == ACTION_MOVE)
        actionMove(segment, false);
      else if (declaredAction == ACTION_CHARGE)
        {
          if (actionMove(segment, true))
            actionAttack(segment, true);
        }
      else if (declaredAction == ACTION_DRAW)
        {
          var item = character.inventory.getByID(targetID);
          if (character.weapon.weapon.id != 'unarmed')
            log(segment, nameCapped + ' sheathe' +
              (isPlayer ? ' your ' : 's their ') +
              character.weapon.getNameLower() +
              ' and draw' +
              (isPlayer ? '' : 's') + ' the ' +
              item.getNameLower() + '.');
          else log(segment, nameCapped + ' draw' +
            (isPlayer ? '' : 's') + ' a ' +
            item.getNameLower() + '.');
          character.draw(item);
        }
      else if (declaredAction == ACTION_WAIT)
        {
          log(segment, nameCapped + ' cautiously wait' +
            (isPlayer ? '' : 's') + '.');
        }
      else if (declaredAction == ACTION_ATTACK)
        actionAttack(segment, false);

      else if (declaredAction == ACTION_PARRY)
        {
          if (wasAttacked)
            log(segment, nameCapped + ' ' +
              (isPlayer ? 'try' : 'tries') + ' to parry incoming enemy attacks.');
          else log(segment, nameCapped + ' stand' +
            (isPlayer ? '' : 's') + ' ready to parry enemy attacks.');
        }

      else if (declaredAction == ACTION_RETREAT)
        actionRetreat(segment);

      declaredAction = ACTION_WAIT;
    }

// retreat from combat
  function actionRetreat(segment: Int)
    {
      // cannot retreat if no friends are in the group
      if (combat.getGroupEnemies(group, isEnemy) > 0 &&
          combat.getGroupEnemies(group, !isEnemy) == 1)
        {
          log(segment, nameCapped + ' do' +
            (isPlayer ? '' : 'es') + ' not manage to retreat from combat.');
          return;
        }

      // find which way is "out"
      var minx = 10000, maxx = 0;
      for (op in combat.opponents)
        {
          if (op.x < minx)
            minx = op.x;
          if (op.x > maxx)
            maxx = op.x;
        }
      var move = Std.int(getMove() / 2);
      move -= move % 10;
      if (x - minx > maxx - x)
        x -= move;
      else x += move;
      group = combat.getMinFreeGroup();
      log(segment, nameCapped + ' retreat' +
        (isPlayer ? '' : 's') + ' from combat ' +
        (move > 0 ? ' (' + move + '\')' : '') + '.');
    }

// move/charge opponent to target
// returns true on success
  function actionMove(segment: Int, isCharge: Bool): Bool
    {
      var move = getMove();
      if (isCharge)
        move *= 2;

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
          return false;
        }

      var target = combat.getFirstGroupOpponent(targetID);
      var dst = distanceToOpponent(target);
      // NOTE: 10' is melee range
      if (dst <= move + 10) // add to target group
        {
          x = target.x;
          group = targetID;
          move = dst - 10;
          if (move < 0)
            move = 0;
        }
      else
        {
          // separate into new group if not solo already
          if (combat.getGroupMembers(group) > 1)
            group = combat.getMaxGroup() + 1;
          // target to the left
          if (target.x < x)
            x -= move;
          // target to the right
          else x += move;
        }

      var targetStr = ' group ' + String.fromCharCode(65 + targetID);
      if (combat.getGroupEnemies(targetID, isEnemy) == 1)
        {
          var targetOp = combat.getFirstGroupOpponent(targetID);
          targetStr = targetOp.name;
        }
      log(segment, nameCapped + ' ' +
        (isCharge ? 'charge' : 'close') +
        (isPlayer ? '' : 's') +
        ' into combat ' +
        (move > 0 ? ' (' + move + '\')' : '') +
        ' with ' + targetStr + '.');
      return true;
    }

// attack random opponent in the same group
// can be called after charge
  function actionAttack(segment: Int, isCharge: Bool)
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
          if (!isCharge)
            log(segment, nameCapped + ' cautiously wait' +
              (isPlayer ? '' : 's') + '.');
          return;
        }
      if (isCharge)
        lastChargeRound = combat.round;

      // pick random target and attack
      var target = targets[Std.random(targets.length)];
      target.wasAttacked = true;
/*
      // target will get a pre-counterattack if weapon length allows
      // TODO check for ranged too
      if (isCharge && 
          (target.type == COMBAT_NPC ||
           target.type == COMBAT_PARTY_MEMBER) &&
          (type == COMBAT_NPC || type == COMBAT_PARTY_MEMBER) &&
          target.meleeWeapon.length > meleeWeapon.length)
        {
          target.actionAttack(segment, false);
          isDead
        }
*/
      var targetAC = target.getAC();
      var parryBonus = 0;
      if ((target.type == COMBAT_NPC ||
          target.type == COMBAT_PARTY_MEMBER) &&
          target.isParrying)
        {
          parryBonus = - 2 - target.character.strStats.toHitBonus;
          if (parryBonus > 0)
            parryBonus = 0;
        }
      if (type == COMBAT_MONSTER)
        {
          var thac = _TablesFighter.instance.thac(monster.level,
            targetAC);
          for (atk in 0...monster.attacks)
            {
              var atkName = monster.attackNames[atk];
              var roll = Const.dice(1, 20) +
                (isCharge ? 2 : 0) +
                parryBonus;
              var ext = ' [rolls ' + roll + ' vs ' + thac + ' (AC ' +
                targetAC + ')' +
                (isCharge ? ', +2 from charge' : '') +
                (target.isParrying ? ', ' + parryBonus + ' from parry' : '') +
                ']';
              if (roll < thac)
                {
                  log(segment, nameCapped + ' ' +
                    (isPlayer ? 'try' : 'tries') + ' to ' + atkName +
                    ' ' + target.name + ', but miss' +
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

              log(segment, nameCapped + ' ' + atkName +
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
            character.strStats.toHitBonus +
            (isCharge ? 2 : 0);
          var ext = ' [rolls ' + roll + ' vs ' + thac + ' (AC ' +
            targetAC + ')';
          if (character.strStats.toHitBonus != 0)
            {
              if (character.strStats.toHitBonus > 0)
                ext += ', +' + character.strStats.toHitBonus;
              else ext += ', ' + character.strStats.toHitBonus;
              ext += ' from STR';
            }
          if (isCharge)
            ext += ', +2 from charge';
          if (target.isParrying)
            ext += ', ' + parryBonus + ' from parry';
          ext += ']';

          if (roll < thac)
            {
              log(segment, nameCapped + ' ' +
                (isPlayer ? 'try' : 'tries') + ' to ' +
                character.weapon.weapon.attackMelee + ' ' +
                target.name + ', but miss' +
                (isPlayer ? '' : 'es') + '.' +
                (game.extendedInfo ? ext : ''));
              return;
            }
          // TODO vs large
          // NOTE: copy array to apply bonuses
          var row = Reflect.copy(character.weapon.weapon.damageVsMedium);
          row[2] += character.strStats.toDamageBonus;
          var dmg = Const.dice(row[0], row[1]) + row[2];
          if (dmg < 0)
            dmg = 0;
          ext += ' [DMG ' + row[0] + 'd' + row[1] +
            (row[2] > 0 ? '+' + row[2] : '') + 
            (row[2] < 0 ? '' + row[2] : '') +
            ' = ' + dmg + ']';

          log(segment, nameCapped + ' ' +
            (isPlayer ?
             character.weapon.weapon.attackMelee :
             character.weapon.weapon.attackMelee2) + ' ' +
            target.name + ' for ' + dmg + ' damage.' +
            (game.extendedInfo ? ext : ''));
          target.hp -= dmg;
          if (target.hp <= 0)
            target.isDead = true;
        }
    }

// helper: returns current opponent move
  function getMove(): Int
    {
      if (type == COMBAT_MONSTER)
        return monster.move;
      else if (type == COMBAT_PARTY_MEMBER || type == COMBAT_NPC)
        return character.move;
      return 0;
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
        combat.logRound += 'S' + segment + ':\n';
      combat.logRound += '&nbsp;&nbsp;' + s + '\n';
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
          if (isDead)
            s += '~~';
#if mydebug
          s += ' <span class=consoleDebug>[' +
            hp + '/' + maxHP + ' hp]</span>';
#end
        }
      else if (type == COMBAT_PARTY_MEMBER)
        {
          s += ' (' + hp + '/' + maxHP + ' hp)';
          if (isDead)
            s += '~~';
        }
#if mydebug
          s += ' <span class=consoleDebug>[x: ' + x + ']</span>';
#end
      return s + '\n';
    }
}

@:enum
abstract _CombatOpponentType(String) {
  var COMBAT_PARTY_MEMBER = 'COMBAT_PARTY_MEMBER';
  var COMBAT_NPC = 'COMBAT_NPC';
  var COMBAT_MONSTER = 'COMBAT_MONSTER';
}
