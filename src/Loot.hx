// any loot that can be sold
class Loot extends Item
{
  public function new(parent: Obj)
    {
      super(parent);
      type = 'loot';
      setAttr(LOOT);
    }
}
