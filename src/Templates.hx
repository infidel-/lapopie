/**
ROOM

private class X extends Room
{
  public function new(parent: Obj)
    {
      super(parent);
      id = '';
      name = '';
      desc = '';
    }
}

ITEM

private class C extends Item
{
  public function new(parent: Obj)
    {
      super(parent);
      id = '';
      name = '';
      names = [];
      initial = '';
      desc = '';
    }
}

LOOT

private class C extends Loot
{
  public function new(parent: Obj)
    {
      super(parent);
      id = '';
      name = '';
      names = [];
      initial = '';
      desc = '';
      value = 1 * GP;
    }
}

OBJ

private class B extends Obj
{
  public function new(parent: Obj)
    {
      super(parent);
      id = '';
      name = '';
      names = [];
      initial = '';
      desc = '';
    }
}

BEFORE/DURING/AFTER

  public override function before()
    {
      switch (state.action)
        {
          case X:
            return false;
          default:
            return super.before();
        }
      return true;
    }

  override function during()
    {
      switch (action)
        {
          case X:
          default:
            super.during();
        }
    }

  public override function after(): String
    {
      switch (state.action)
        {
          case X:
            return '';
          default:
            return super.after();
        }
    }

**/
