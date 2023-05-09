// party of characters (player or npcs)
class Party extends Obj
{
  public function new(parent: Obj)
    {
      super(parent);
      type = 'party';
      names = [];
    }
}
