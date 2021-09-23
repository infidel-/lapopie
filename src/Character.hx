class Character
{
  var game: Game;
  public var stats: Stats;
  public var strStats: _StrStats;
  public var dexStats(get,never): _DexStats;
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

  // inventory and equipment 
  public var inventory: Inventory;
  public var armor: Item;
  public var weapon: Item;
  public var shield: Item;

  // fake items for equipment
  var unarmedItem: Item;
  var noArmorItem: Item;

  public function new(g: Game, c: _CharacterClass, s: Stats)
    {
      game = g;
      stats = s;
      className = c;
      inventory = new Inventory(game, this);
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
      while (true)
        {
          hp = maxHP = Const.dice(1, classTables.hitDie) +
            classTables.conStats[stats.con].hpBonus;
          if (hp >= 4)
            break;
        }
      xp = 0;
      level = 1;
      unarmedItem = new Item();
      unarmedItem.type == ITEM_WEAPON;
      unarmedItem.weapon = _ItemsTables.weapons['unarmed'];
      weapon = unarmedItem;
      noArmorItem = new Item();
      noArmorItem.type = ITEM_ARMOR;
      noArmorItem.armor = _ItemsTables.armor['none'];
      armor = shield = noArmorItem;
      ac = 0;
      move = 90;
      recalc();
    }

// give item by type/string id and wear it if necessary
  public function giveItem(t: _ItemType, key: String, wear: Bool)
    {
      if (t == ITEM_ARMOR)
        {
          var tmp = _ItemsTables.armor[key];
          if (tmp == null)
            throw 'no such armor: ' + key;

          var item = new Item();
          item.id = inventory.getEmptyID();
          item.type = t;
          item.armor = tmp;
          if (wear)
            {
              if (tmp.isShield)
                shield = item;
              else armor = item;
            }
          else inventory.add(item);
        }
      else if (t == ITEM_POTION)
        {
          var tmp = _ItemsTables.potions[key];
          if (tmp == null)
            throw 'no such potion: ' + key;

          var item = new Item();
          item.id = inventory.getEmptyID();
          item.type = t;
          item.potion = tmp;
          item.potionDoses = item.potion.doses;
          inventory.add(item);
        }
      else if (t == ITEM_WEAPON)
        {
          var tmp = _ItemsTables.weapons[key];
          if (tmp == null)
            throw 'no such weapon: ' + key;

          var item = new Item();
          item.id = inventory.getEmptyID();
          item.type = t;
          item.weapon = tmp;
          inventory.add(item);
          if (wear)
            draw(item);
        }
      else throw 'Not implemented: giveItem(' + t + ')';
      recalc();
    }

// draw weapon
  public function draw(item: Item)
    {
      // remove old
      if (weapon.weapon.id != 'unarmed')
        {
          weapon.id = inventory.getEmptyID();
          inventory.list.add(weapon);
        }
      // drawing two-handed - remove shield
      if (!item.weapon.canShield && shield.armor.id != 'none')
        {
          shield.id = inventory.getEmptyID();
          inventory.list.add(shield);
          shield = noArmorItem;
        }
      inventory.list.remove(item);
      weapon = item;
      // drawing one-handed - auto-draw shield
      if (weapon.weapon.canShield)
        {
          // find best shield in inventory
          var bestShield: Item = null;
          for (item in inventory.list)
            {
              if (item.type != ITEM_ARMOR)
                continue;
              if (!item.armor.isShield)
                continue;
              if (bestShield == null ||
                  item.armor.cost > bestShield.armor.cost)
                bestShield = item;
            }
          if (bestShield != null)
            {
              inventory.list.remove(item);
              shield = bestShield;
            }
        }
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
      ac = 10 + armor.armor.ac +
        _TablesClass.instance.dexStats[stats.dex].acAdj;
    }

// print character HP
  public function printHP(): String
    {
      var perc = 100.0 * hp / maxHP;
      if (perc < 33 || (hp < maxHP && hp <= 2))
        return '<span class=wounded33>' + hp + '</span>';
      else if (perc < 66)
        return '<span class=wounded66>' + hp + '</span>';
      else if (perc < 100)
        return '<span class=wounded99>' + hp + '</span>';
      else return '' + hp;
    }

// print this character in console
  public function print(): String
    {
      var sb = new StringBuf();
      sb.add('**' + nameCapped + '**\n' +
        'STR ' + stats.str +
        (stats.str18 > 0 ? '(' + stats.str18 + ')' : '') + ', ' +
        'DEX ' + stats.dex + ', ' +
        'CON ' + stats.con + ', ' +
        'INT ' + stats.int + ', ' +
        'WIS ' + stats.wis + ', ' +
        'CHA ' + stats.cha + ' | ' +
        'HP ' + printHP() + '/' + maxHP + ', ' +
        'AC ' + ac + ', ' +
        'XP ' + xp + ', ' +
        'LVL ' + level + '\n');
      var wpn = weapon.weapon;
      var dmgBonus = wpn.damageVsMedium[2];
      if (wpn.type == WEAPONTYPE_MELEE || wpn.type == WEAPONTYPE_BOTH)
        strStats.toDamageBonus;
      sb.add('&nbsp;&nbsp;' + wpn.name +
        ' (' + wpn.damageVsMedium[0] + 'd' +
        wpn.damageVsMedium[1] +
        (dmgBonus < 0 ? '' + dmgBonus : '') +
        (dmgBonus > 0 ? '+' + dmgBonus : '') + ')');
      if (wpn.type == WEAPONTYPE_RANGED) // || wpn.type == WEAPONTYPE_BOTH)
        sb.add(', range ' + wpn.range + "'");
      sb.add('\n');
      if (shield.armor.id != 'none')
        {
          sb.add('&nbsp;&nbsp;' + shield.getName() + '\n');
        }
      sb.add('&nbsp;&nbsp;' + armor.getName() + ' (AC ' +
        (10 + armor.armor.ac) + ')');
      var s = sb.toString();
//      s = s.substr(0, s.length - 2);
//      s += '</span>';
      return s;
    }

  function get_dexStats() return _TablesClass.instance.dexStats[stats.dex];
}
