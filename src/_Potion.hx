typedef _Potion = {
  var id: String;
  var name: String;
  var note: String;
  var doses: Int;
  var cost: Int;
  var onDrink: Character -> Int -> String;
  var canDrink: Character -> _DrinkResult;
}

typedef _DrinkResult = {
  var result: Bool;
  var msg: String;
}
