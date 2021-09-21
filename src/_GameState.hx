// game state

@:enum
abstract _GameState(String) {
  var STATE_CHARGEN = 'STATE_CHARGEN';
  var STATE_CHAT = 'STATE_CHAT';
  var STATE_COMBAT = 'STATE_COMBAT';
  var STATE_LOCATION = 'STATE_LOCATION';
}
