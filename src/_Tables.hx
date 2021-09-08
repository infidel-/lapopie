@:expose
class _Tables
{
  // roll required to hit armor class
  public static function printThac(thacf: Int -> Int -> Int)
    {
      for (level in 0...10)
        {
          var s = 'Level ' + level + ' : ';
          for (ac in -10...11)
            s += thacf(level, ac) + ', ';
          trace(s);
        }
    }

// generic thac row function
  public static function thacCommon(level: Int, ac: Int, last20ac: Int): Int
    {
      if (ac >= last20ac)
        return 20 + last20ac - ac;
      else if (ac > last20ac - 5 && ac < last20ac)
        return 20;
      else if (ac <= last20ac - 5)
        return 20 - 5 - ac + last20ac;
      return 99;
    }

// convert monster hit dice into level
  public static function hitDiceToLevel(hitDice: Int, hdBonus: Int): Int
    {
      var x = hitDice * 10 + hdBonus;
      if (x < 9)
        return 0;
      else if (x == 9)
        return 1;
      else if (x == 10)
        return 2;
      else if (x <= 20)
        return 3;
      else if (x <= 30)
        return 4;
      else if (x <= 40)
        return 5;
      else if (x <= 50)
        return 6;
      else if (x <= 60)
        return 7;
      else if (x <= 70)
        return 8;
      else if (x <= 80)
        return 9;
      else if (x <= 90)
        return 10;
      else throw "hit dice too high: " + x;
    }
}
