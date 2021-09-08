@:expose
class _TablesThief extends _TablesClass
{
  public function new()
    {
      super();
      hitDie = 6; // d6
    }

// roll required to hit armor class
  static var levelToMod = [ 2, 1, 1, 1, 1, -1, -1, -1, -1, -4, -4, -4, -4 ];
  public override function thac(level: Int, ac: Int): Int
    {
      return _Tables.thacCommon(level, ac, levelToMod[level]);
    }

// level -> value
  public static var savingThrows = [
    // 1-4
    1 => {
      rodStaffWand: 14,
      breathWeapons: 16,
      deathParalysisPoison: 13,
      petrifactionPolymorph: 12,
      spellsUnlisted: 15,
    },
    // 5-8
    5 => {
      rodStaffWand: 12,
      breathWeapons: 15,
      deathParalysisPoison: 12,
      petrifactionPolymorph: 11,
      spellsUnlisted: 13,
    },
    // 9-12
    9 => {
      rodStaffWand: 10,
      breathWeapons: 14,
      deathParalysisPoison: 11,
      petrifactionPolymorph: 10,
      spellsUnlisted: 11,
    },
  ];

  public static var instance = new _TablesThief();
}
