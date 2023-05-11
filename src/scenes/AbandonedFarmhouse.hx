// abandoned farmhouse scene
package scenes;

class AbandonedFarmhouse extends Scene
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'abandonedFarmhouse';
      name = 'Abandoned Farmhouse Scene';
      dm = "You see a bleak, abandoned farmhouse by the forest road, its forlorn visage revealing years of decay. Aged walls stand firm, as a decaying chimney and untamed garden exude a somber mood. Yet, despite its desolation, the farmhouse hold an odd allure, beckoning you with the promise of forgotten secrets and hidden treasures within.";
      addChild(new Front(this));
      addChild(new LivingArea(this));
      addChild(new Kitchen(this));
    }
}

class Front extends Room
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'front';
      name = 'Abandoned Farmhouse (front)';
     desc = 'It stands like a forgotten sentinel beside the forest road, its roof sagging with age and its walls streaked with moss and rust. The front door to the north is old but sturdy, and darkened windows peer out like empty sockets on either side.';
// #TODO: scenery - garden, bushes, chimney
      addChild(new FrontDoor(this));
      addChild(new LeftWindow(this));
      addChild(new RightWindow(this));
      nTo = 'frontDoor';
      cantGo = 'The farmhouse waits for you to unravel its hidden secrets.';
    }
}

private class LeftWindow extends Obj
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'leftWindow';
      name = 'left window';
      names = [ 'left', 'window' ];
      desc = 'The window is covered with a thick layer of dirt.';
// TODO: dust and wiping the dust
// TODO: foundIn = [ 'bedroom' ]
      setAttr(CONCEALED);
    }

  public override function before()
    {
      switch (state.action)
        {
          case SEARCH:
            p('#TODO');
          default:
            return super.before();
        }
      return true;
    }
}

private class RightWindow extends Door
{
  var dusty: Bool;
  public function new(parent: Obj)
    {
      super(parent);
      id = 'rightWindow';
      name = 'right window';
      names = [ 'right', 'window' ];
      dusty = true;
// TODO: foundIn = [ 'kitchen' ]
// TODO: climb, open, unlock, break
// TODO: sound
// TODO: clean dirt
      setAttr(CONCEALED);
    }

  override function descF()
    {
      var s = 'This window is large enough to climb into. ';
      if (dusty)
        s += 'It is covered with a thick layer of dirt.';
      else s += 'You have wiped the dirt away from the window.';
      return s;
    }

  public override function before()
    {
      switch (state.action)
        {
          case RUB:
            if (!dusty)
              {
                p("You've already cleaned the dirt off.");
                return false;
              }
          case SEARCH:
            if (dusty)
              {
                p('The window has too much dirt on it to see inside.');
                return false;
              }
          default:
            return super.before();
        }
      return true;
    }

  public override function after(): String
    {
      switch (state.action)
        {
          case RUB:
            dusty = false;
            return "You wipe the dirt off the right window.";
          case SEARCH:
            var kitchen = scene.findObject('kitchen').asRoom();
            var s = 'You peer through the window:\n';
            s += kitchen.descRoom(true);
            return s;
          default:
            return super.after();
        }
    }
}

private class FrontDoor extends Door
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'frontDoor';
      name = 'front door';
      names = [ 'front', 'wooden', 'door', 'old', 'sturdy' ];
      desc = 'The door is made of thick oak, with visible grooves and knots that give it a rugged, weathered look. The brass doorknob is tarnished, and there are scratches and dings on the surface.';
// TODO: doorknob, turn it
      doorTo = 'livingArea';
      doorDir = NORTH;
    }

  public override function after(): String
    {
      switch (state.action)
        {
          case OPEN:
            return 'The door opens with a slight creak.';
          default:
            return super.after();
        }
      return '';
    }
}

private class LivingArea extends Room
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'livingArea';
      name = 'Living Area';
// #TODO: temp
// #TODO: what if player wants to make fire?
// #TODO: cobwebs as a hint!
// could be a good solution to get rid of the spider!
// but we need some wood (barn?)
      desc = 'The weight of time rests upon dust-covered relics and a cold hearth, hinting at darker fates. A mounted black wolf head and time-worn longbow adorn the walls. The layout reveals multiple passages: a dark, open doorway to the west; a slightly ajar door to the east; and an unyielding, closed door to the north, each promising to unveil a mysterious history.';
      addChild(new ClayMug(this));
    }
}

private class ClayMug extends Item
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'clayMug';
      name = 'clay mug';
      names = [ 'old', 'aged', 'weathered', 'clay', 'mug', 'tankard', 'cup' ];
      desc = 'An aged clay mug bears the scars of time with its faded colors and intricate web of cracks.';
      initial = 'An old, weathered clay mug lies forgotten on the dusty floor.';
// #TODO: when thrown, shatters (make a new attribute, FRAGILE - also use it for potions, for example)
    }
}

private class Kitchen extends Room
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'kitchen';
      name = 'Kitchen';
      desc = "In the forsaken kitchen, filth and rubble litter the space. A gaping trapdoor beckons from the northeast ceiling corner, while a passage with a tattered door leads north, and another door heads west. A grimy cauldron sits in the fireplace, a skeletal hand protruding ominously from it.";

      addChild(new Barrel(this));
/** TODO
The door to the west is slightly ajar, and there is a bucket perched precariously on top of it.

A heap of garments and a ripped backpack lie abandoned on the floor.

The cauldron brims with an assortment of bones, raising the chilling question: are they human?
**/
    }
}

private class Barrel extends Obj
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'barrel';
      name = 'old barrel';
      names = [ 'old', 'barrel' ];
      initial = 'An ancient barrel rests near the fireplace.';
    }
}
