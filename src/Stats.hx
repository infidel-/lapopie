// player/npc stats

@:structInit class Stats
{
  public var str: Int;
  public var str18: Int; // -1: dont use percentage
  public var dex: Int;
  public var con: Int;
  public var int: Int;
  public var wiz: Int;
  public var cha: Int;


  public function new(str, str18, dex, con, int, wiz, cha)
    {
      this.str = str;
      this.str18 = str18;
      if (this.str == 18 && this.str18 == 0)
        this.str18 = Std.random(100);
      this.dex = dex;
      this.con = con;
      this.int = int;
      this.wiz = wiz;
      this.cha = cha;
    }
}
