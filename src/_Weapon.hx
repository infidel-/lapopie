typedef _Weapon = {
  var id: String;
  var name: String;
  var type: _WeaponType;
  @:optional var attackMelee: String;
  @:optional var attackMelee2: String;
  @:optional var attackRanged: String;
  @:optional var attackRanged2: String;
  @:optional var shots: Int;
  var damageVsMedium: Array<Int>;
  var damageVsLarge: Array<Int>;
  @:optional var range: Int;
  @:optional var length: Int;
  var weight: Float;
  var cost: Int;
}

enum _WeaponType {
  WEAPONTYPE_MELEE;
  WEAPONTYPE_RANGED;
  WEAPONTYPE_BOTH;
}
