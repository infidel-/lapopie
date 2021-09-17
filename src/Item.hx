// character inventory/equipment item

class Item
{
  public var id: Int; // unique for each inventory
  public var amount: Int;

  // type-based links
  public var type: _ItemType;
  public var weapon: _Weapon;
  public var armor: _Armor;

  public function new()
    {
      id = 0;
      amount = 1;
    }

// get item string ID
  public function getID(): String
    {
      if (type == ITEM_WEAPON)
        return weapon.id;
      else if (type == ITEM_ARMOR)
        return armor.id;
      return '?todo?';
    }

// get item name
  public function getName(): String
    {
      if (type == ITEM_WEAPON)
        return weapon.name;
      else if (type == ITEM_ARMOR)
        return armor.name;
      return '?todo?';
    }

// get item name in lowercase
  public inline function getNameLower(): String
    {
      return getName().toLowerCase();
    }
}
