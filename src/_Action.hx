// all verbs

@:enum
abstract _Action(String) {
  var CLOSE = 'CLOSE';
  var DROP = 'DROP';
  var GO = 'GO';
  var GODIR = 'GODIR';
  var ENTER = 'ENTER';
  var EXAMINE = 'EXAMINE';
  var INVENTORY = 'INVENTORY';
  var LOOK = 'LOOK';
  var OPEN = 'OPEN';
  var TAKE = 'TAKE';
  var SEARCH = 'SEARCH';
  var UNLOCK = 'UNLOCK';
}