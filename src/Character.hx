class Character
{
  var game: Game;
  public var stats: Stats;
  public var strStats: _StrStats;
  public var name: String;
  public var nameCapped: String;
  public var className: _CharacterClass;
  public var classTables: _TablesClass;
  public var isPlayer: Bool;
  public var hp: Int;
  public var maxHP: Int;
  public var xp: Int;
  public var level: Int;
  public var ac: Int;
  public var move: Int;

  // equipment
  public var armor: _Armor;
  public var meleeWeapon: _MeleeWeapon;

  public function new(g: Game, c: _CharacterClass, s: Stats)
    {
      game = g;
      stats = s;
      className = c;
      if (c == CLASS_FIGHTER)
        classTables = _TablesFighter.instance;
      else if (c == CLASS_CLERIC)
        classTables = _TablesCleric.instance;
      else if (c == CLASS_THIEF)
        classTables = _TablesThief.instance;
      else throw "No class tables for " + c;
      isPlayer = false;
      name = '?';
      nameCapped = '?';
      hp = maxHP = Const.dice(1, classTables.hitDie) +
        classTables.conStats[stats.con].hpBonus;
      xp = 0;
      level = 1;
      armor = _ItemsTables.armor['none'];
      meleeWeapon = _ItemsTables.meleeWeapons['unarmed'];
      ac = 0;
      move = 90;
      recalc();
    }

// give and wear melee weapon
  public function giveAndWearMeleeWeapon(key: String)
    {
      var tmp = _ItemsTables.meleeWeapons[key];
      if (tmp == null)
        throw 'no such melee weapon: ' + key;
      meleeWeapon = tmp;

      recalc();
    }

// give and wear armor
  public function giveAndWearArmor(key: String)
    {
      var tmp = _ItemsTables.armor[key];
      if (tmp == null)
        throw 'no such armor: ' + key;
      armor = tmp;

      recalc();
    }

// recalc all dynamic stats
  public function recalc()
    {
      var strval = stats.str * 100 + stats.str18;
      var strkey = 0;
      for (key in _TablesClass.instance.strStats.keys())
        if (strval <= key)
          {
            strkey = key;
            break;
          }
      strStats = _TablesClass.instance.strStats[strkey];
      ac = 10 + armor.ac +
        _TablesClass.instance.dexStats[stats.dex].acAdj;
    }

// print this character in console
  public function print(): String
    {
      var sb = new StringBuf();
      sb.add('<span class=consoleSys>' + nameCapped + '\n' +
        'STR ' + stats.str +
        (stats.str18 > 0 ? '(' + stats.str18 + ')' : '') + ', ' +
        'DEX ' + stats.dex + ', ' +
        'CON ' + stats.con + ', ' +
        'INT ' + stats.int + ', ' +
        'WIZ ' + stats.wiz + ', ' +
        'CHA ' + stats.cha + ' | ' +
        'HP ' + hp + '/' + maxHP + ', ' +
        'AC ' + ac + ', ' +
        'XP ' + xp + ', ' +
        'LVL ' + level + '\n');
      var dmgBonus = meleeWeapon.damageVsMedium[2] +
        strStats.toDamageBonus;
      sb.add('&nbsp;&nbsp;' + meleeWeapon.name +
        ' (' + meleeWeapon.damageVsMedium[0] + 'd' +
        meleeWeapon.damageVsMedium[1] +
        (dmgBonus < 0 ? '' + dmgBonus : '') +
        (dmgBonus > 0 ? '+' + dmgBonus : '') + ')\n');
      sb.add('&nbsp;&nbsp;' + armor.name + ' (AC ' + (10 + armor.ac) + ')');
      var s = sb.toString();
//      s = s.substr(0, s.length - 2);
      s += '</span>';
      return s;
    }
}