// player/npc stats

@:structInit class Stats
{
  public var str: Int;
  public var str18: Int; // -1: dont use percentage
  public var dex: Int;
  public var con: Int;
  public var int: Int;
  public var wis: Int;
  public var cha: Int;


  public function new(str, str18, dex, con, int, wis, cha)
    {
      this.str = str;
      this.str18 = str18;
      if (this.str == 18 && this.str18 == 0)
        this.str18 = Std.random(100);
      this.dex = dex;
      this.con = con;
      this.int = int;
      this.wis = wis;
      this.cha = cha;
    }

// get stat value by index
  public function get(idx: Int): Int
    {
      return Reflect.field(this, order[idx]);
    }

// set stat value by index
  public function set(idx: Int, val: Int)
    {
      Reflect.setField(this, order[idx], val);
    }

// get chargen colored stat string
  public function getChargenString(idx: Int, minStats: Array<Int>): String
    {
      var val = get(idx);
      var s = '<span class=' + (val >= minStats[idx] ? 'normal' : 'red') +
        '>' + order[idx].toUpperCase() + ' ' + val + 
        (val < minStats[idx] ? ' (min ' + minStats[idx] + ')' : '') +
        '</span>';
      return s;
    }

// check for min stats and return error string
// returns empty string if all stats are fine
  public function checkMin(minStats: Array<Int>): String
    {
      var s = '';
      for (i in 0...6)
        {
          var val = get(i);
          if (val < minStats[i])
            s += 'Your ' + names[i] + ' is too low.\n';
        }
      return s;
    }

  static var order = [ 'str', 'dex', 'con', 'int', 'wis', 'cha' ];
  static var names = [ 'strength', 'dexterity', 'constitution', 'intelligence', 'wisdom', 'charisma' ];
}
