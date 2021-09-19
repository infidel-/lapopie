// character inventory/equipment item

class Item
{
  public var id: Int; // unique for each inventory
  public var amount: Int;

  // type-based links
  public var type: _ItemType;
  public var weapon: _Weapon;
  public var armor: _Armor;
  public var potion: _Potion;
  public var potionDoses: Int;

  public function new()
    {
      id = 0;
      amount = 1;
    }

// print item in inventory (actually just return string)
  public function print(): String
    {
      var s = getName();
      if (type == ITEM_WEAPON)
        {
          var dmg = weapon.damageVsMedium;
          s += ' (' + dmg[0] + 'd' + dmg[1] +
            (dmg[2] < 0 ? '' + dmg[2] : '') +
            (dmg[2] > 0 ? '+' + dmg[2] : '') + ')';
        }
      else if (type == ITEM_ARMOR)
        s += ' (AC adj ' + armor.ac + ')';
      else if (type == ITEM_POTION)
        s += ' (' + potionDoses + '/' + potion.doses + ' doses left)';
      return s;
    }

// get item string ID
  public function getID(): String
    {
      if (type == ITEM_WEAPON)
        return weapon.id;
      else if (type == ITEM_ARMOR)
        return armor.id;
      else if (type == ITEM_POTION)
        return potion.id;
      return '?todo?';
    }

// get item name
  public function getName(): String
    {
      if (type == ITEM_WEAPON)
        return weapon.name;
      else if (type == ITEM_ARMOR)
        return armor.name;
      else if (type == ITEM_POTION)
        return potion.name;
      return '?todo?';
    }

// get item name in lowercase
  public inline function getNameLower(): String
    {
      return getName().toLowerCase();
    }
}
