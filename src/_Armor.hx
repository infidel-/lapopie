typedef _Armor = {
  var id: String;
  var name: String;
  var weight: Int;
  var moveRate: Int;
  var ac: Int;
  var cost: Int;
  @:optional var isShield: Bool;
  @:optional var maxAttacksBlocked: Int;
}
