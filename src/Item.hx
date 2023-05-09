// item that can be picked up and put into inventory
// TODO: will probably add weight and volume later
class Item extends Obj
{
  public function new(parent: Obj)
    {
      super(parent);
      unsetAttr(STATIC);
    }
}
