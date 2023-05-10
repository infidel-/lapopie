// abandoned farmhouse scene
package scenes;

/*
   class World
*/

class AbandonedFarmhouse extends Scene
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'abandonedFarmhouse';
      name = 'Abandoned Farmhouse Scene';
      addChild(new Front(this));
      addChild(new LivingArea(this));
    }
}

class Front extends Room
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'front';
      name = 'Abandoned Farmhouse (front)';
// #TODO: temp
      desc = 'It stands like a forgotten sentinel beside the forest road, its roof sagging with age and its walls streaked with moss and rust. The front door to the north is old but sturdy, and darkened windows peer out like empty sockets on either side. Yet, despite its desolation, the farmhouse seems to hold a strange allure, beckoning you with the promise of forgotten secrets and hidden treasures within.';
// #TODO: scenery
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
            p('Looking through the window, you see what appears to be a bedroom. #TODO');
          default:
            return super.before();
        }
      return true;
    }
}

private class RightWindow extends Obj
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'rightWindow';
      name = 'right window';
      names = [ 'right', 'window' ];
      desc = 'The window is covered with a thick layer of dirt.';
// TODO: dust and wiping the dust
// TODO: foundIn = [ 'kitchen' ]
      setAttr(CONCEALED);
    }

  public override function before()
    {
      switch (state.action)
        {
          case SEARCH:
            p('Looking through the window, you see what appears to be a kitchen. #TODO');
          default:
            return super.before();
        }
      return true;
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

class LivingArea extends Room
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

class ClayMug extends Item
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
