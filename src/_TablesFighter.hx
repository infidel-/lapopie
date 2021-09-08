@:expose
class _TablesFighter extends _TablesClass
{
  public function new()
    {
      super();
      hitDie = 10; // d10
      // fighters get more hp with high con
      conStats[17].hpBonus = 3;
      conStats[18].hpBonus = 4;
      conStats[19].hpBonus = 5;
    }
// roll required to hit armor class
  public override function thac(level: Int, ac: Int): Int
    {
      return _Tables.thacCommon(level, ac, 1 - level);
    }

// level -> value
  public static var savingThrows = [
    // 0
    0 => {
      rodStaffWand: 18,
      breathWeapons: 20,
      deathParalysisPoison: 16,
      petrifactionPolymorph: 17,
      spellsUnlisted: 19,
    },
    // 1-2
    1 => {
      rodStaffWand: 16,
      breathWeapons: 17,
      deathParalysisPoison: 14,
      petrifactionPolymorph: 15,
      spellsUnlisted: 17,
    },
    // 3-4
    3 => {
      rodStaffWand: 15,
      breathWeapons: 16,
      deathParalysisPoison: 13,
      petrifactionPolymorph: 14,
      spellsUnlisted: 16,
    },
    // 5-6
    5 => {
      rodStaffWand: 13,
      breathWeapons: 13,
      deathParalysisPoison: 11,
      petrifactionPolymorph: 12,
      spellsUnlisted: 14,
    },
    // 7-8
    7 => {
      rodStaffWand: 12,
      breathWeapons: 12,
      deathParalysisPoison: 10,
      petrifactionPolymorph: 11,
      spellsUnlisted: 13,
    },
    // 9-10
    9 => {
      rodStaffWand: 10,
      breathWeapons: 9,
      deathParalysisPoison: 8,
      petrifactionPolymorph: 9,
      spellsUnlisted: 11,
    },
  ];

  public static var instance = new _TablesFighter();
}
