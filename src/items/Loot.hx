// various loot
package items;

class FeatheredHat extends Loot
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'featheredHat';
      name = 'feathered hat';
      names = [ 'feathered', 'hat', 'cap' ];
      desc = 'A meticulously crafted hat of fine materials, adorned with an array of colorful feathers.';
// TODO
//      price = 1 * GP;
//      setAttr(HIDDEN);
    }
}

class SilkScarf extends Loot
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'silkScarf';
      name = 'silk scarf';
      names = [ 'silk', 'scarf' ];
      desc = 'The luxurious silk scarf exudes captivating sheen and displays exceptional craftsmanship.';
// TODO
//      price = 1 * GP;
//      setAttr(HIDDEN);
    }
}

class SilverMirror extends Loot
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'silverMirror';
      name = 'silver mirror';
      names = [ 'silver', 'mirror' ];
      desc = "The petite silver mirror, featuring delicate engravings, offers an elegant way to check one's appearance on the go.";
//      price = 1 * GP;
    }
}

class SilverComb extends Loot
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'silverComb';
      name = 'silver comb';
      names = [ 'silver', 'comb' ];
      desc = "The silver comb, crafted with elegance, is a stylish accessory for grooming and maintaining a polished appearance.";
//      price = 1 * GP;
    }
}
