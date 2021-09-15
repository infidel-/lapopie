class _TablesClass
{
  public function new() {}
  public var hitDie = 0;

  public function thac(level: Int, ac: Int): Int
    {
      throw 'cannot call base thac()';
    }

  // STRENGTH
  // NOTE: key x10 for 18(xx)
  public var strStats: Map<Int, _StrStats> = [
    300 => {
      toHitBonus: -3,
      toDamageBonus: -1,
      encAdj: -35,
      minorTests: 1, // 1-x
      majorTests: 0,
    },
    400 => {
      toHitBonus: -2,
      toDamageBonus: -1,
      encAdj: -25,
      minorTests: 1, // 1-x
      majorTests: 0,
    },
    500 => {
      toHitBonus: -2,
      toDamageBonus: -1,
      encAdj: -25,
      minorTests: 1, // 1-x
      majorTests: 0,
    },
    600 => {
      toHitBonus: -1,
      toDamageBonus: 0,
      encAdj: -15,
      minorTests: 1, // 1-x
      majorTests: 0,
    },
    700 => {
      toHitBonus: -1,
      toDamageBonus: 0,
      encAdj: -15,
      minorTests: 1, // 1-x
      majorTests: 0,
    },
    800 => {
      toHitBonus: 0,
      toDamageBonus: 0,
      encAdj: 0,
      minorTests: 2, // 1-x
      majorTests: 1,
    },
    900 => {
      toHitBonus: 0,
      toDamageBonus: 0,
      encAdj: 0,
      minorTests: 2, // 1-x
      majorTests: 1,
    },
    1000 => {
      toHitBonus: 0,
      toDamageBonus: 0,
      encAdj: 0,
      minorTests: 1, // 1-x
      majorTests: 2,
    },
    1100 => {
      toHitBonus: 0,
      toDamageBonus: 0,
      encAdj: 0,
      minorTests: 1, // 1-x
      majorTests: 2,
    },
    1200 => {
      toHitBonus: 0,
      toDamageBonus: 0,
      encAdj: 10,
      minorTests: 2, // 1-x
      majorTests: 4,
    },
    1300 => {
      toHitBonus: 0,
      toDamageBonus: 0,
      encAdj: 10,
      minorTests: 2, // 1-x
      majorTests: 4,
    },
    1400 => {
      toHitBonus: 0,
      toDamageBonus: 0,
      encAdj: 20,
      minorTests: 2, // 1-x
      majorTests: 7,
    },
    1500 => {
      toHitBonus: 0,
      toDamageBonus: 0,
      encAdj: 20,
      minorTests: 2, // 1-x
      majorTests: 7,
    },
    1600 => {
      toHitBonus: 0,
      toDamageBonus: 1,
      encAdj: 35,
      minorTests: 3, // 1-x
      majorTests: 10,
    },
    1700 => {
      toHitBonus: 1,
      toDamageBonus: 1,
      encAdj: 50,
      minorTests: 3, // 1-x
      majorTests: 13,
    },
    1800 => {
      toHitBonus: 1,
      toDamageBonus: 2,
      encAdj: 75,
      minorTests: 3, // 1-x
      majorTests: 16,
    },
    1850 => { // 18.01-18.50
      toHitBonus: 1,
      toDamageBonus: 3,
      encAdj: 100,
      minorTests: 3, // 1-x
      majorTests: 20,
    },
    1875 => {
      toHitBonus: 2,
      toDamageBonus: 3,
      encAdj: 125,
      minorTests: 4, // 1-x
      majorTests: 25,
    },
    1890 => {
      toHitBonus: 2,
      toDamageBonus: 4,
      encAdj: 150,
      minorTests: 4, // 1-x
      majorTests: 30,
    },
    1899 => {
      toHitBonus: 2,
      toDamageBonus: 5,
      encAdj: 200,
      minorTests: 4, // 1-x
      majorTests: 35,
    },
    1900 => {
      toHitBonus: 3,
      toDamageBonus: 6,
      encAdj: 300,
      minorTests: 5, // 1-x
      majorTests: 40,
    },
  ];

  // DEXTERITY
  public var dexStats: Map<Int, _DexStats> = [
    3 => {
      surpriseBonus: -3,
      missileBonusToHit: -3,
      acAdj: 4,
    },
    4 => {
      surpriseBonus: -2,
      missileBonusToHit: -2,
      acAdj: 3,
    },
    5 => {
      surpriseBonus: -1,
      missileBonusToHit: -1,
      acAdj: 2,
    },
    6 => {
      surpriseBonus: 0,
      missileBonusToHit: 0,
      acAdj: 1,
    },
    7 => {
      surpriseBonus: 0,
      missileBonusToHit: 0,
      acAdj: 0,
    },
    8 => {
      surpriseBonus: 0,
      missileBonusToHit: 0,
      acAdj: 0,
    },
    9 => {
      surpriseBonus: 0,
      missileBonusToHit: 0,
      acAdj: 0,
    },
    10 => {
      surpriseBonus: 0,
      missileBonusToHit: 0,
      acAdj: 0,
    },
    11 => {
      surpriseBonus: 0,
      missileBonusToHit: 0,
      acAdj: 0,
    },
    12 => {
      surpriseBonus: 0,
      missileBonusToHit: 0,
      acAdj: 0,
    },
    13 => {
      surpriseBonus: 0,
      missileBonusToHit: 0,
      acAdj: 0,
    },
    14 => {
      surpriseBonus: 0,
      missileBonusToHit: 0,
      acAdj: 0,
    },
    15 => {
      surpriseBonus: 0,
      missileBonusToHit: 0,
      acAdj: -1,
    },
    16 => {
      surpriseBonus: 1,
      missileBonusToHit: 1,
      acAdj: -2,
    },
    17 => {
      surpriseBonus: 2,
      missileBonusToHit: 2,
      acAdj: -3,
    },
    18 => {
      surpriseBonus: 3,
      missileBonusToHit: 3,
      acAdj: -4,
    },
    19 => {
      surpriseBonus: 3,
      missileBonusToHit: 3,
      acAdj: -4,
    },
  ];

  // CONSTITUTION
  public var conStats = [
    3 => {
      hpBonus: -2,
      surviveRaiseDead: 40,
      surviveSystemShock: 35,
    },
    4 => {
      hpBonus: -1,
      surviveRaiseDead: 45,
      surviveSystemShock: 40,
    },
    5 => {
      hpBonus: -1,
      surviveRaiseDead: 50,
      surviveSystemShock: 45,
    },
    6 => {
      hpBonus: -1,
      surviveRaiseDead: 55,
      surviveSystemShock: 50,
    },
    7 => {
      hpBonus: 0,
      surviveRaiseDead: 60,
      surviveSystemShock: 55,
    },
    8 => {
      hpBonus: 0,
      surviveRaiseDead: 65,
      surviveSystemShock: 60,
    },
    9 => {
      hpBonus: 0,
      surviveRaiseDead: 70,
      surviveSystemShock: 65,
    },
    10 => {
      hpBonus: 0,
      surviveRaiseDead: 75,
      surviveSystemShock: 70,
    },
    11 => {
      hpBonus: 0,
      surviveRaiseDead: 80,
      surviveSystemShock: 75,
    },
    12 => {
      hpBonus: 0,
      surviveRaiseDead: 85,
      surviveSystemShock: 80,
    },
    13 => {
      hpBonus: 0,
      surviveRaiseDead: 90,
      surviveSystemShock: 85,
    },
    14 => {
      hpBonus: 0,
      surviveRaiseDead: 92,
      surviveSystemShock: 88,
    },
    15 => {
      hpBonus: 1,
      surviveRaiseDead: 94,
      surviveSystemShock: 91,
    },
    16 => {
      hpBonus: 2,
      surviveRaiseDead: 96,
      surviveSystemShock: 95,
    },
    17 => {
      hpBonus: 2,
      surviveRaiseDead: 98,
      surviveSystemShock: 97,
    },
    18 => {
      hpBonus: 2,
      surviveRaiseDead: 100,
      surviveSystemShock: 99,
    },
    19 => {
      hpBonus: 2,
      surviveRaiseDead: 100,
      surviveSystemShock: 99,
    },
  ];

  public static var instance = new _TablesClass();
}
