@:expose
class _TablesCleric extends _TablesClass
{
  public function new()
    {
      super();
      hitDie = 8; // d8
    }
  public static var toHitPenaltyNonProf = -3;
  // str, dex, con, int, wis, cha
  public static var minStats = [ 6, 3, 6, 6, 9, 6 ];

// roll required to hit armor class
  static var levelToMod = [ 1, 0, 0, 0, -2, -2, -2, -4, -4, -4, -6, -6, -6 ];
  public override function thac(level: Int, ac: Int): Int
    {
      return _Tables.thacCommon(level, ac, levelToMod[level]);
    }

// level -> value
  public static var savingThrows = [
    // 1-3
    1 => {
      rodStaffWand: 14,
      breathWeapons: 16,
      deathParalysisPoison: 10,
      petrifactionPolymorph: 13,
      spellsUnlisted: 15,
    },
    // 4-6
    4 => {
      rodStaffWand: 13,
      breathWeapons: 15,
      deathParalysisPoison: 9,
      petrifactionPolymorph: 12,
      spellsUnlisted: 14,
    },
    // 7-9
    7 => {
      rodStaffWand: 11,
      breathWeapons: 13,
      deathParalysisPoison: 7,
      petrifactionPolymorph: 10,
      spellsUnlisted: 12,
    },
  ];

  public static var advancement = [
    // 0
    {
      exp: 0,
      hitDice: 1,
      spells: [ 0, 0, 0, 0, 0 ],
      weaponProfs: 2,
    },
    // 1
    {
      exp: 0,
      hitDice: 1,
      spells: [ 1, 0, 0, 0, 0 ],
      weaponProfs: 2,
    },
    // 2
    {
      exp: 1550,
      hitDice: 2,
      spells: [ 2, 0, 0, 0, 0 ],
      weaponProfs: 2,
    },
    // 3
    {
      exp: 2900,
      hitDice: 3,
      spells: [ 2, 1, 0, 0, 0 ],
      weaponProfs: 3,
    },
    // 4
    {
      exp: 6000,
      hitDice: 4,
      spells: [ 3, 2, 0, 0, 0 ],
      weaponProfs: 3,
    },
    // 5
    {
      exp: 13250,
      hitDice: 5,
      spells: [ 3, 3, 1, 0, 0 ],
      weaponProfs: 4,
    },
    // 6
    {
      exp: 27000,
      hitDice: 6,
      spells: [ 3, 3, 2, 0, 0 ],
      weaponProfs: 4,
    },
    // 7
    {
      exp: 55000,
      hitDice: 7,
      spells: [ 3, 3, 2, 1, 0 ],
      weaponProfs: 5,
    },
    // 8
    {
      exp: 110000,
      hitDice: 8,
      spells: [ 3, 3, 3, 2, 0 ],
      weaponProfs: 5,
    },
    // 9
    {
      exp: 220000,
      hitDice: 9,
      spells: [ 4, 4, 3, 2, 1 ],
      weaponProfs: 6,
    },
  ];

  public var wisStats = [
    9 => {
      bonusSpells: [ 0, 0, 0, 0 ],
      spellFailureChance: 15,
    },
    10 => {
      bonusSpells: [ 0, 0, 0, 0 ],
      spellFailureChance: 10,
    },
    11 => {
      bonusSpells: [ 0, 0, 0, 0 ],
      spellFailureChance: 5,
    },
    12 => {
      bonusSpells: [ 0, 0, 0, 0 ],
      spellFailureChance: 1,
    },
    13 => {
      bonusSpells: [ 1, 0, 0, 0 ],
      spellFailureChance: 0,
    },
    14 => {
      bonusSpells: [ 2, 0, 0, 0 ],
      spellFailureChance: 0,
    },
    15 => {
      bonusSpells: [ 2, 1, 0, 0 ],
      spellFailureChance: 0,
    },
    16 => {
      bonusSpells: [ 2, 2, 0, 0 ],
      spellFailureChance: 0,
    },
    17 => {
      bonusSpells: [ 2, 2, 1, 0 ],
      spellFailureChance: 0,
    },
    18 => {
      bonusSpells: [ 2, 2, 1, 1 ],
      spellFailureChance: 0,
    },
    19 => {
      bonusSpells: [ 3, 2, 1, 1 ],
      spellFailureChance: 0,
    },
  ];

  public static var instance = new _TablesCleric();
}
