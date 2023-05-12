// all object attributes

@:enum
abstract _Attribute(String) {
// ''Concealed from view but present.'' The player object has this;
// an object which was the player until ChangePlayer happened loses this property;
// a concealed door can't be entered;
// does not appear in room descriptions.
  var CONCEALED = 'CONCEALED';

// Affects scope and light;
// object lists recurse through it if open (or transparent);
// may be described as **closed, open, locked, empty**;
// a possession will give it a LetGo action if the player tries to remove it, or a Receive if something is put in;
// things can be taken or removed from it, or inserted into it, but only if it is open;
// likewise for ''transfer'' and ''empty'';
// room descriptions describe using when_open or when_closed if given;
// if there is no defined description, an Examine causes the contents to be searched (i.e. written out) rather than a message ''You see nothing special about. . .'';
// Search only reveals the contents of containers, otherwise saying ''You find nothing''. Note: an object cannot be both a container and a supporter.
  var CONTAINER = 'CONTAINER';

// ''Is a door or bridge.'' Room descriptions describe using when_open or when_closed if given;
// and an Enter action becomes a Go action. If a Go has to go through this object, then: if concealed, the player ''can't go that way'';
// if not open, then the player is told either that this cannot be ascended or descended (if the player tried ''up'' or ''down''), or that it is in the way (otherwise);
// but if neither, then its door_to property is consulted to see where it leads;
// finally, if this is zero, then it is said to ''lead nowhere'' and otherwise the player actually moves to the location.
  var DOOR = 'DOOR';

// ''Can be eaten'' (and thus removed from game).
  var EDIBLE = 'EDIBLE';

// Can't be opened. If a container and also lockable, may be called ''locked'' in inventories.
  var LOCKED = 'LOCKED';

// Can be locked or unlocked by a player holding its key object, which is given by the property with_key;
// if a container and also locked, may be called ''locked'' in inventories.
  var LOCKABLE = 'LOCKABLE';

// ''Has been or is being held by the player.'' Objects (immediately) owned by the player after Initialise has run are given it;
// at the end of each turn, if an item is newly held by the player and is scored, it is given moved and OBJECT_SCORE points are awarded;
// an object's initial message only appears in room descriptions if it is unmoved.
  var MOVED = 'MOVED';

// Can be opened or closed, unless locked.
  var OPENABLE = 'OPENABLE';

// ''Open door or container.'' Affects scope and light;
// lists (such as inventories) recurse through an open container;
// if a container, called ''open'' by some descriptions;
// things can be taken or removed from an open container;
// similarly inserted, transferred or emptied. A container can only be entered or exited if it is both enterable and open. An open door can be entered. Described by when_open in room descriptions.
  var OPEN = 'OPEN';

// ''Fixed in place'' if player tries to take, remove, pull, push or turn.
  var STATIC = 'STATIC';

// ''Has been or is being visited by the player.'' Given to a room immediately after a Look first happens there: if this room is scored then ROOM_SCORE points are awarded. Affects whether room descriptions are abbreviated or not.
// given to scenes on entry to any room in it
  var VISITED = 'VISITED';
}
