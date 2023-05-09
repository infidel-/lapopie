// PC, NPC or monster
class Character extends Obj
{
  public function new(parent: Obj)
    {
      super(parent);
      this.type = 'party';
    }
}
