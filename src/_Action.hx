// all verbs

@:enum
abstract _Action(String) {
  var ATTACK = 'ATTACK';
  var CLOSE = 'CLOSE';
  var DROP = 'DROP';
  var DEBUG = 'DEBUG';
  var EAT = 'EAT';
  var ENTER = 'ENTER';
  var EXAMINE = 'EXAMINE';
  var GO = 'GO';
  var GODIR = 'GODIR';
  var INVENTORY = 'INVENTORY';
  var LOOK = 'LOOK';
  var OPEN = 'OPEN';
  var RUB = 'RUB';
  var SMELL = 'SMELL';
  var SEARCH = 'SEARCH';
  var TAKE = 'TAKE';
  var TOUCH = 'TOUCH';
  var UNLOCK = 'UNLOCK';
}
