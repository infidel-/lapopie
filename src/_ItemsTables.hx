class _ItemsTables
{
  public static var armor: Map<String, _Armor> = [
    'none' => {
      id: 'none',
      name: 'No armor',
      weight: 0,
      moveRate: 120,
      ac: 0,
      cost: 0,
    },
    'leather' => {
      id: 'leather',
      name: 'Leather armor',
      weight: 15,
      moveRate: 120,
      ac: -2,
      cost: 500,
    },
    'padded' => {
      id: 'padded',
      name: 'Padded gambeson',
      weight: 10,
      moveRate: 90,
      ac: -2,
      cost: 400,
    },
    'ring' => {
      id: 'ring',
      name: 'Ring mail',
      weight: 35,
      moveRate: 90,
      ac: -3,
      cost: 3000,
    },
    'studded' => {
      id: 'studded',
      name: 'Studded armor',
      weight: 20,
      moveRate: 90,
      ac: -3,
      cost: 1500,
    },
    'scale' => {
      id: 'scale',
      name: 'Scale mail',
      weight: 40,
      moveRate: 60,
      ac: -4,
      cost: 4500,
    },
    'chain' => {
      id: 'chain',
      name: 'Chain mail',
      weight: 30,
      moveRate: 90,
      ac: -5,
      cost: 7500,
    },
    'splint' => {
      id: 'splint',
      name: 'Splint armor',
      weight: 40,
      moveRate: 60,
      ac: -6,
      cost: 8000,
    },
    'banded' => {
      id: 'banded',
      name: 'Banded armor',
      weight: 35,
      moveRate: 90,
      ac: -6,
      cost: 9000,
    },
    'plate' => {
      id: 'plate',
      name: 'Plate armor',
      weight: 45,
      moveRate: 60,
      ac: -7,
      cost: 40000,
    },

    'shieldSmall' => {
      id: 'shieldSmall',
      name: 'Small shield',
      weight: 5,
      moveRate: 0,
      ac: -1,
      cost: 1000,
    },
    'shieldMedium' => {
      id: 'shieldMedium',
      name: 'Medium shield',
      weight: 8,
      moveRate: 0,
      ac: -1,
      cost: 1200,
    },
    'shieldLarge' => {
      id: 'shieldLarge',
      name: 'Large shield',
      weight: 10,
      moveRate: 0,
      ac: -1,
      cost: 1500,
    },
  ];

  public static var meleeWeapons: Map<String, _MeleeWeapon> = [
    'unarmed' => {
      id: 'unarmed',
      name: 'Unarmed',
      attackName: 'punch',
      attackName2: 'punches',
      damageVsMedium: [ 1, 2, 0 ], // XdY+Z
      damageVsLarge: [ 1, 2, 0 ], // XdY+Z
      length: 1,
      weight: 0,
      cost: 0,
    },
    'battleAxe' => {
      id: 'battleAxe',
      name: 'Battle axe',
      attackName: 'hack',
      attackName2: 'hacks',
      damageVsMedium: [ 1, 8, 0 ], // XdY+Z
      damageVsLarge: [ 1, 8, 0 ], // XdY+Z
      length: 4,
      weight: 7,
      cost: 500,
    },
    'handAxe' => {
      id: 'handAxe',
      name: 'Hand axe',
      attackName: 'hack',
      attackName2: 'hacks',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 4, 0 ], // XdY+Z
      length: 3,
      weight: 5,
      cost: 100,
    },
    'club' => {
      id: 'club',
      name: 'Club',
      attackName: 'club',
      attackName2: 'clubs',
      damageVsMedium: [ 1, 4, 0 ], // XdY+Z
      damageVsLarge: [ 1, 3, 0 ], // XdY+Z
      length: 3,
      weight: 3,
      cost: 2,
    },
    'dagger' => {
      id: 'dagger',
      name: 'Dagger',
      attackName: 'stab',
      attackName2: 'stabs',
      damageVsMedium: [ 1, 4, 0 ], // XdY+Z
      damageVsLarge: [ 1, 3, 0 ], // XdY+Z
      length: 2,
      weight: 1,
      cost: 2,
    },
    'heavyFlail' => {
      id: 'heavyFlail',
      name: 'Heavy flail',
      attackName: 'smash',
      attackName2: 'smashes',
      damageVsMedium: [ 1, 6, 1 ], // XdY+Z
      damageVsLarge: [ 2, 4, 0 ], // XdY+Z
      length: 4,
      weight: 10,
      cost: 300,
    },
    'lightFlail' => {
      id: 'lightFlail',
      name: 'Light flail',
      attackName: 'smash',
      attackName2: 'smashes',
      damageVsMedium: [ 1, 4, 1 ], // XdY+Z
      damageVsLarge: [ 1, 4, 1 ], // XdY+Z
      length: 3,
      weight: 4,
      cost: 600,
    },
    'halberd' => {
      id: 'halberd',
      name: 'Halberd',
      attackName: 'crush',
      attackName2: 'crushes',
      damageVsMedium: [ 1, 10, 0 ], // XdY+Z
      damageVsLarge: [ 2, 6, 0 ], // XdY+Z
      length: 6,
      weight: 18,
      cost: 900,
    },
    'heavyWarhammer' => {
      id: 'heavyWarhammer',
      name: 'Heavy war hammer',
      attackName: 'bludgeon',
      attackName2: 'bludgeons',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 6, 1 ], // XdY+Z
      length: 4,
      weight: 10,
      cost: 700,
    },
    'lightWarhammer' => {
      id: 'lightWarhammer',
      name: 'Light war hammer',
      attackName: 'bludgeon',
      attackName2: 'bludgeons',
      damageVsMedium: [ 1, 4, 1 ], // XdY+Z
      damageVsLarge: [ 1, 4, 0 ], // XdY+Z
      length: 3,
      weight: 5,
      cost: 100,
    },
    'lance' => {
      id: 'lance',
      name: 'Lance',
      attackName: 'stab',
      attackName2: 'stabs',
      damageVsMedium: [ 2, 4, 1 ], // XdY+Z
      damageVsLarge: [ 3, 6, 0 ], // XdY+Z
      length: 6,
      weight: 15,
      cost: 600,
    },
    'heavyMace' => {
      id: 'heavyMace',
      name: 'Heavy mace',
      attackName: 'bludgeon',
      attackName2: 'bludgeons',
      damageVsMedium: [ 1, 6, 1 ], // XdY+Z
      damageVsLarge: [ 1, 6, 0 ], // XdY+Z
      length: 4,
      weight: 10,
      cost: 1000,
    },
    'lightMace' => {
      id: 'lightMace',
      name: 'Light mace',
      attackName: 'bludgeon',
      attackName2: 'bludgeons',
      damageVsMedium: [ 1, 4, 1 ], // XdY+Z
      damageVsLarge: [ 1, 4, 1 ], // XdY+Z
      length: 3,
      weight: 5,
      cost: 400,
    },
    'morningStar' => {
      id: 'morningStar',
      name: 'Morning star',
      attackName: 'crush',
      attackName2: 'crushes',
      damageVsMedium: [ 2, 4, 0 ], // XdY+Z
      damageVsLarge: [ 1, 6, 1 ], // XdY+Z
      length: 4,
      weight: 12,
      cost: 500,
    },
    'heavyPick' => {
      id: 'heavyPick',
      name: 'Heavy pick',
      attackName: 'hit',
      attackName2: 'hits',
      damageVsMedium: [ 1, 6, 1 ], // XdY+Z
      damageVsLarge: [ 2, 4, 0 ], // XdY+Z
      length: 4,
      weight: 10,
      cost: 800,
    },
    'lightPick' => {
      id: 'lightPick',
      name: 'Light pick',
      attackName: 'hit',
      attackName2: 'hits',
      damageVsMedium: [ 1, 4, 1 ], // XdY+Z
      damageVsLarge: [ 1, 4, 0 ], // XdY+Z
      length: 4,
      weight: 4,
      cost: 500,
    },
    'polearm' => {
      id: 'polearm',
      name: 'Pole arm',
      attackName: 'smash',
      attackName2: 'smashes',
      damageVsMedium: [ 1, 6, 1 ], // XdY+Z
      damageVsLarge: [ 1, 10, 0 ], // XdY+Z
      length: 6,
      weight: 8,
      cost: 600,
    },
    'spear' => {
      id: 'spear',
      name: 'Spear',
      attackName: 'impale',
      attackName2: 'impales',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 8, 0 ], // XdY+Z
      length: 6,
      weight: 5,
      cost: 100,
    },
    'staff' => {
      id: 'staff',
      name: 'Staff',
      attackName: 'beat',
      attackName2: 'beats',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 6, 0 ], // XdY+Z
      length: 6,
      weight: 5,
      cost: 0,
    },
    'bastardSword' => {
      id: 'bastardSword',
      name: 'Bastard sword',
      attackName: 'slash',
      attackName2: 'slashes',
      damageVsMedium: [ 2, 4, 0 ], // XdY+Z
      damageVsLarge: [ 2, 8, 0 ], // XdY+Z
      weight: 10,
      cost: 2500,
    },
    'broadSword' => {
      id: 'broadSword',
      name: 'Broad sword',
      attackName: 'slash',
      attackName2: 'slashes',
      damageVsMedium: [ 2, 4, 0 ], // XdY+Z
      damageVsLarge: [ 1, 6, 1 ], // XdY+Z
      length: 4,
      weight: 8,
      cost: 1000,
    },
    'longSword' => {
      id: 'longSword',
      name: 'Long sword',
      attackName: 'slash',
      attackName2: 'slashes',
      damageVsMedium: [ 1, 8, 0 ], // XdY+Z
      damageVsLarge: [ 1, 12, 0 ], // XdY+Z
      length: 4,
      weight: 7,
      cost: 1500,
    },
    'scimitar' => {
      id: 'scimitar',
      name: 'Scimitar',
      attackName: 'slash',
      attackName2: 'slashes',
      damageVsMedium: [ 1, 8, 0 ], // XdY+Z
      damageVsLarge: [ 1, 8, 0 ], // XdY+Z
      length: 4,
      weight: 5,
      cost: 1500,
    },
    'shortSword' => {
      id: 'shortSword',
      name: 'Short sword',
      attackName: 'slash',
      attackName2: 'slashes',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 8, 0 ], // XdY+Z
      length: 3,
      weight: 3,
      cost: 800,
    },
    'twohandedSword' => {
      id: 'twohandedSword',
      name: 'Two-handed sword',
      attackName: 'chop',
      attackName2: 'chops',
      damageVsMedium: [ 1, 10, 0 ], // XdY+Z
      damageVsLarge: [ 3, 6, 0 ], // XdY+Z
      length: 5,
      weight: 25,
      cost: 3000,
    },
  ];
}
