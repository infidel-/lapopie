class _MonstersTable
{
  public static var list: Map<String, _Monster> = [
    'wildDog' => {
      id: 'wildDog',
      nameCapped: 'Wild dog',
      name: 'wild dog',
      size: SIZE_SMALL,
      move: 150,
      ac: 7,
      hitDice: [ 1, 8, 0 ], // XdY+Z
      attacks: 1,
      attackNames: [ 'bite' ],
      damage: [ [ 1, 4, 0 ] ], // array of XdY+Z
      level: 1,
      xp: 10,
      xpBonus: 1, // per hp
    },
  ];

  public static var SIZE_SMALL = 0;
  public static var SIZE_MEDIUM = 1;
  public static var SIZE_LARGE = 2;
}
