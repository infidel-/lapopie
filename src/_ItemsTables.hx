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
      isShield: true,
      maxAttacksBlocked: 1,
      weight: 5,
      moveRate: 0,
      ac: -1,
      cost: 1000,
    },
    'shieldMedium' => {
      id: 'shieldMedium',
      name: 'Medium shield',
      isShield: true,
      maxAttacksBlocked: 2,
      weight: 8,
      moveRate: 0,
      ac: -1,
      cost: 1200,
    },
    'shieldLarge' => {
      id: 'shieldLarge',
      name: 'Large shield',
      isShield: true,
      maxAttacksBlocked: 3,
      weight: 10,
      moveRate: 0,
      ac: -1,
      cost: 1500,
    },
  ];

  // NOTE: cost in cp (x100)
  public static var weapons: Map<String, _Weapon> = [
    // ================== MELEE WEAPONS =======================
    'unarmed' => {
      id: 'unarmed',
      name: 'Unarmed',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'punch',
      attackMelee2: 'punches',
      damageVsMedium: [ 1, 2, 0 ], // XdY+Z
      damageVsLarge: [ 1, 2, 0 ], // XdY+Z
      length: 1,
      weight: 0,
      cost: 0,
    },
    'battleAxe' => {
      id: 'battleAxe',
      name: 'Battle axe',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'hack',
      attackMelee2: 'hacks',
      damageVsMedium: [ 1, 8, 0 ], // XdY+Z
      damageVsLarge: [ 1, 8, 0 ], // XdY+Z
      length: 4,
      weight: 7,
      cost: 500,
    },
    'handAxe' => {
      id: 'handAxe',
      name: 'Hand axe',
      type: WEAPONTYPE_BOTH,
      canShield: true,
      attackMelee: 'hack',
      attackMelee2: 'hacks',
      attackRanged: 'throw an axe at ',
      attackRanged2: 'throws an axe at ',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 4, 0 ], // XdY+Z
      length: 3,
      range: 20,
      weight: 5,
      cost: 100,
    },
    'club' => {
      id: 'club',
      name: 'Club',
      type: WEAPONTYPE_BOTH,
      canShield: true,
      attackMelee: 'club',
      attackMelee2: 'clubs',
      attackRanged: 'throw a club at ',
      attackRanged2: 'throws a club at ',
      damageVsMedium: [ 1, 4, 0 ], // XdY+Z
      damageVsLarge: [ 1, 3, 0 ], // XdY+Z
      length: 3,
      range: 20,
      weight: 3,
      cost: 2,
    },
    'dagger' => {
      id: 'dagger',
      name: 'Dagger',
      type: WEAPONTYPE_BOTH,
      canShield: true,
      attackMelee: 'stab',
      attackMelee2: 'stabs',
      attackRanged: 'throw a dagger at ',
      attackRanged2: 'throws a dagger at ',
      damageVsMedium: [ 1, 4, 0 ], // XdY+Z
      damageVsLarge: [ 1, 3, 0 ], // XdY+Z
      shots: 2,
      range: 20,
      length: 2,
      weight: 1,
      cost: 200,
    },
    'dart' => {
      id: 'dart',
      name: 'Dart',
      type: WEAPONTYPE_BOTH,
      canShield: true,
      attackMelee: 'stick',
      attackMelee2: 'sticks',
      attackRanged: 'throw a dart at ',
      attackRanged2: 'throws a dart at ',
      damageVsMedium: [ 1, 3, 0 ], // XdY+Z
      damageVsLarge: [ 1, 2, 0 ], // XdY+Z
      shots: 3,
      range: 25,
      length: 2,
      weight: 0.5,
      cost: 20,
    },
    'heavyFlail' => {
      id: 'heavyFlail',
      name: 'Heavy flail',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'smash',
      attackMelee2: 'smashes',
      damageVsMedium: [ 1, 6, 1 ], // XdY+Z
      damageVsLarge: [ 2, 4, 0 ], // XdY+Z
      length: 4,
      weight: 10,
      cost: 300,
    },
    'lightFlail' => {
      id: 'lightFlail',
      name: 'Light flail',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'smash',
      attackMelee2: 'smashes',
      damageVsMedium: [ 1, 4, 1 ], // XdY+Z
      damageVsLarge: [ 1, 4, 1 ], // XdY+Z
      length: 3,
      weight: 4,
      cost: 600,
    },
    'halberd' => {
      id: 'halberd',
      name: 'Halberd',
      type: WEAPONTYPE_MELEE,
      attackMelee: 'crush',
      attackMelee2: 'crushes',
      damageVsMedium: [ 1, 10, 0 ], // XdY+Z
      damageVsLarge: [ 2, 6, 0 ], // XdY+Z
      length: 6,
      weight: 18,
      cost: 900,
    },
    'heavyWarhammer' => {
      id: 'heavyWarhammer',
      name: 'Heavy war hammer',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'bludgeon',
      attackMelee2: 'bludgeons',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 6, 1 ], // XdY+Z
      length: 4,
      weight: 10,
      cost: 700,
    },
    'lightWarhammer' => {
      id: 'lightWarhammer',
      name: 'Light war hammer',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'bludgeon',
      attackMelee2: 'bludgeons',
      damageVsMedium: [ 1, 4, 1 ], // XdY+Z
      damageVsLarge: [ 1, 4, 0 ], // XdY+Z
      length: 3,
      weight: 5,
      cost: 100,
    },
    'lance' => {
      id: 'lance',
      name: 'Lance',
      type: WEAPONTYPE_MELEE,
      attackMelee: 'stab',
      attackMelee2: 'stabs',
      damageVsMedium: [ 2, 4, 1 ], // XdY+Z
      damageVsLarge: [ 3, 6, 0 ], // XdY+Z
      length: 6,
      weight: 15,
      cost: 600,
    },
    'heavyMace' => {
      id: 'heavyMace',
      name: 'Heavy mace',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'bludgeon',
      attackMelee2: 'bludgeons',
      damageVsMedium: [ 1, 6, 1 ], // XdY+Z
      damageVsLarge: [ 1, 6, 0 ], // XdY+Z
      length: 4,
      weight: 10,
      cost: 1000,
    },
    'lightMace' => {
      id: 'lightMace',
      name: 'Light mace',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'bludgeon',
      attackMelee2: 'bludgeons',
      damageVsMedium: [ 1, 4, 1 ], // XdY+Z
      damageVsLarge: [ 1, 4, 1 ], // XdY+Z
      length: 3,
      weight: 5,
      cost: 400,
    },
    'morningStar' => {
      id: 'morningStar',
      name: 'Morning star',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'crush',
      attackMelee2: 'crushes',
      damageVsMedium: [ 2, 4, 0 ], // XdY+Z
      damageVsLarge: [ 1, 6, 1 ], // XdY+Z
      length: 4,
      weight: 12,
      cost: 500,
    },
    'heavyPick' => {
      id: 'heavyPick',
      name: 'Heavy pick',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'hit',
      attackMelee2: 'hits',
      damageVsMedium: [ 1, 6, 1 ], // XdY+Z
      damageVsLarge: [ 2, 4, 0 ], // XdY+Z
      length: 4,
      weight: 10,
      cost: 800,
    },
    'lightPick' => {
      id: 'lightPick',
      name: 'Light pick',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'hit',
      attackMelee2: 'hits',
      damageVsMedium: [ 1, 4, 1 ], // XdY+Z
      damageVsLarge: [ 1, 4, 0 ], // XdY+Z
      length: 4,
      weight: 4,
      cost: 500,
    },
    'polearm' => {
      id: 'polearm',
      name: 'Pole arm',
      type: WEAPONTYPE_MELEE,
      attackMelee: 'smash',
      attackMelee2: 'smashes',
      damageVsMedium: [ 1, 6, 1 ], // XdY+Z
      damageVsLarge: [ 1, 10, 0 ], // XdY+Z
      length: 6,
      weight: 8,
      cost: 600,
    },
    'spear' => {
      id: 'spear',
      name: 'Spear',
      type: WEAPONTYPE_BOTH,
      canShield: true,
      attackMelee: 'impale',
      attackMelee2: 'impales',
      attackRanged: 'throw a spear at ',
      attackRanged2: 'throws a spear at ',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 8, 0 ], // XdY+Z
      range: 20,
      length: 6,
      weight: 5,
      cost: 100,
    },
    'staff' => {
      id: 'staff',
      name: 'Staff',
      type: WEAPONTYPE_MELEE,
      attackMelee: 'beat',
      attackMelee2: 'beats',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 6, 0 ], // XdY+Z
      length: 6,
      weight: 5,
      cost: 0,
    },
    'bastardSword' => {
      id: 'bastardSword',
      name: 'Bastard sword',
      type: WEAPONTYPE_MELEE,
      attackMelee: 'slash',
      attackMelee2: 'slashes',
      damageVsMedium: [ 2, 4, 0 ], // XdY+Z
      damageVsLarge: [ 2, 8, 0 ], // XdY+Z
      length: 5,
      weight: 10,
      cost: 2500,
    },
    'broadSword' => {
      id: 'broadSword',
      name: 'Broad sword',
      type: WEAPONTYPE_MELEE,
      attackMelee: 'slash',
      attackMelee2: 'slashes',
      damageVsMedium: [ 2, 4, 0 ], // XdY+Z
      damageVsLarge: [ 1, 6, 1 ], // XdY+Z
      length: 4,
      weight: 8,
      cost: 1000,
    },
    'longSword' => {
      id: 'longSword',
      name: 'Long sword',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'slash',
      attackMelee2: 'slashes',
      damageVsMedium: [ 1, 8, 0 ], // XdY+Z
      damageVsLarge: [ 1, 12, 0 ], // XdY+Z
      length: 4,
      weight: 7,
      cost: 1500,
    },
    'scimitar' => {
      id: 'scimitar',
      name: 'Scimitar',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'slash',
      attackMelee2: 'slashes',
      damageVsMedium: [ 1, 8, 0 ], // XdY+Z
      damageVsLarge: [ 1, 8, 0 ], // XdY+Z
      length: 4,
      weight: 5,
      cost: 1500,
    },
    'shortSword' => {
      id: 'shortSword',
      name: 'Short sword',
      type: WEAPONTYPE_MELEE,
      canShield: true,
      attackMelee: 'slash',
      attackMelee2: 'slashes',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 8, 0 ], // XdY+Z
      length: 3,
      weight: 3,
      cost: 800,
    },
    'twohandedSword' => {
      id: 'twohandedSword',
      name: 'Two-handed sword',
      type: WEAPONTYPE_MELEE,
      attackMelee: 'chop',
      attackMelee2: 'chops',
      damageVsMedium: [ 1, 10, 0 ], // XdY+Z
      damageVsLarge: [ 3, 6, 0 ], // XdY+Z
      length: 5,
      weight: 25,
      cost: 3000,
    },

    // ================== MISSILE WEAPONS =======================
    'shortBow' => {
      id: 'shortBow',
      name: 'Short bow',
      type: WEAPONTYPE_RANGED,
      attackRanged: 'shoot an arrow at ',
      attackRanged2: 'shoots an arrow at ',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 6, 0 ], // XdY+Z
      shots: 2,
      range: 50,
      weight: 8,
      cost: 1500,
    },
    'longBow' => {
      id: 'longBow',
      name: 'Long bow',
      type: WEAPONTYPE_RANGED,
      attackRanged: 'shoot an arrow at ',
      attackRanged2: 'shoots an arrow at ',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 6, 0 ], // XdY+Z
      shots: 2,
      range: 70,
      weight: 12,
      cost: 6000,
    },
    'compShortBow' => {
      id: 'compShortBow',
      name: 'Composite short bow',
      type: WEAPONTYPE_RANGED,
      attackRanged: 'shoot an arrow at ',
      attackRanged2: 'shoots an arrow at ',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 6, 0 ], // XdY+Z
      shots: 2,
      range: 50,
      weight: 9,
      cost: 7500,
    },
    'compLongBow' => {
      id: 'compLongBow',
      name: 'Composite long bow',
      type: WEAPONTYPE_RANGED,
      attackRanged: 'shoot an arrow at ',
      attackRanged2: 'shoots an arrow at ',
      damageVsMedium: [ 1, 6, 0 ], // XdY+Z
      damageVsLarge: [ 1, 6, 0 ], // XdY+Z
      shots: 2,
      range: 60,
      weight: 13,
      cost: 10000,
    },
    'crossbowLight' => {
      id: 'crossbowLight',
      name: 'Light crossbow',
      type: WEAPONTYPE_RANGED,
      attackRanged: 'shoot a bolt at ',
      attackRanged2: 'shoots a bolt at ',
      damageVsMedium: [ 1, 4, 1 ], // XdY+Z
      damageVsLarge: [ 1, 4, 1 ], // XdY+Z
      range: 60,
      weight: 4,
      cost: 1200,
    },
    'hammer' => {
      id: 'hammer',
      name: 'Hammer',
      type: WEAPONTYPE_RANGED,
      canShield: true,
      attackRanged: 'throw a hammer at ',
      attackRanged2: 'throws a hammer at ',
      damageVsMedium: [ 1, 4, 1 ], // XdY+Z
      damageVsLarge: [ 1, 4, 0 ], // XdY+Z
      range: 20,
      weight: 5,
      cost: 100,
    },
    'sling' => {
      id: 'sling',
      name: 'Sling',
      type: WEAPONTYPE_RANGED,
      attackRanged: 'sling a stone at ',
      attackRanged2: 'slings a stone at ',
      damageVsMedium: [ 1, 4, 0 ], // XdY+Z
      damageVsLarge: [ 1, 4, 0 ], // XdY+Z
      range: 35,
      weight: 0.5,
      cost: 50,
    },
  ];
}
