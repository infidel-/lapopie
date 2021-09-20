// character inventory

class Inventory
{
  var game: Game;
  var character: Character;
  public var list: List<Item>;

  public function new(g: Game, ch: Character)
    {
      game = g;
      character = ch;
      list = new List();
    }

// get unused item id
  public function getEmptyID(): Int
    {
      var maxID = 1;
      for (item in list)
        if (item.id > maxID)
          maxID = item.id;
      return maxID + 1;
    }

// add new item, stack if necessary
  public function add(item: Item)
    {
      list.add(item);
      // TODO stacking
    }

// examine an item in the inventory
// 0 - no item found
// 1 - item found, examined
  public function examine(tokens: Array<String>): Int
    {
      // find item by name
      var name = tokens.join(' ');
      var item = null;
      for (it in list)
        if (it.getNameLower() == name)
          {
            item = it;
            break;
          }
      if (item == null)
        return 0;
      game.console.print(item.getNote());
      return 1;
    }

// remove item
  public function remove(item: Item, ?amount: Int = 1)
    {
      list.remove(item);
      // TODO stacking
    }

// print all items of a given type
  public function print(?type: _ItemType = null)
    {
      var s = '';
      var idx = 0;
      for (item in list)
        {
          if (type != null && item.type != type)
            continue;
          s += String.fromCharCode(97 + idx) + ') ' +
            item.print() + '\n';
          idx++;
        }
      game.console.print(s);
    }

// get item of a given type by its index (relative to the type)
  public function get(type: _ItemType, itemIndex: Int)
    {
      var idx = 0;
      for (item in list)
        {
          if (item.type != type)
            continue;
          if (itemIndex == idx)
            return item;
          idx++;
        }
      return null;
    }

// get item by id
  public function getByID(id: Int): Item
    {
      for (item in list)
        if (item.id == id)
          return item;
      return null;
    }
}
