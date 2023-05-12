// food - edible stuff
class Food extends Item
{
  public function new(parent: Obj)
    {
      super(parent);
      type = 'food';
      setAttr(EDIBLE);
    }
}
