// abandoned farmhouse scene
package scenes;

import items.Loot;

class AbandonedFarmhouse extends Scene
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'abandonedFarmhouse';
      name = 'Abandoned Farmhouse Scene';
      dm = "You see a bleak, abandoned farmhouse by the forest road, its forlorn visage revealing years of decay. Aged walls stand firm, as a decaying chimney and untamed garden exude a somber mood. Yet, despite its desolation, the farmhouse holds an odd allure, beckoning you with the promise of forgotten secrets and hidden treasures within.";
      addChild(new Front(this));
      addChild(new LivingArea(this));
      addChild(new Kitchen(this));
      addChild(new Bedroom(this));
      addChild(new StorageArea(this));
      addChild(new Cellar(this));
      addChild(new Attic(this));
      addChild(new Barn(this));
    }
}

private class Front extends Room
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
      cantGo = 'The farmhouse waits for you to unravel its secrets.';
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
// TODO: foundIn = [ 'bedroom' ] + room desc mention
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
  var broken: Bool;
  public function new(parent: Obj)
    {
      super(parent);
      id = 'rightWindow';
      name = 'right window';
      linkedName = 'window';
      names = [ 'right', 'window' ];
      linkedNames = [ 'window' ];
      dusty = true;
      broken = false;
      doorTo = 'kitchen';
      doorDir = NE;
// TODO: sound
      setAttr(CONCEALED);
    }

  override function descF()
    {
      var s = TheName + ' is large enough to climb through.';
      if (broken)
        s += ' It is completely broken.';
      else
        {
          if (dusty)
            s += ' It is covered with a thick layer of dirt.';
          else s += ' You have wiped the dirt away from the window.';
        }
      return s;
    }

  public override function before()
    {
      if (state.action == CLIMB)
        state.action = ENTER;
      switch (state.action)
        {
          case ATTACK:
            if (broken)
              {
                p("You've already broken it.");
                return false;
              }
          case OPEN:
            p("It's completely stuck.");
            return false;
          case RUB:
            if (broken)
              {
                p("It is completely broken.");
                return false;
              }
            else if (!dusty)
              {
                p("You've already cleaned the dirt off.");
                return false;
              }
          case SEARCH:
            if (dusty)
              {
                p('The window has too much dirt on it to see through.');
                return false;
              }
          default:
            return super.before();
        }
      return true;
    }

  override function during()
    {
      switch (action)
        {
          case ATTACK:
            broken = true;
            dusty = false;
            untyped linkedObj.broken = true;
            untyped linkedObj.dusty = false;
            setAttr(OPEN);
// #TODO: sound propagation
          default:
            super.during();
        }
    }

  public override function after(): String
    {
      switch (state.action)
        {
          case ATTACK:
            return "**CRASH!** As you shatter the window, the sound of broken glass echoes all around.";
          case RUB:
            dusty = false;
            untyped linkedObj.dusty = false;
            return "You wipe the dirt off " + theName + ".";
          case SEARCH:
            var s = 'You peer through the window:\n';
            var roomID = null;
            if (actor.getRoom().id == 'front')
              {
                var door: KitchenDoor = cast scene.findObject('kitchenDoor');
                door.bucketFound();
                roomID = 'kitchen';
              }
            else roomID = 'front';
            var room = scene.findObject(roomID).asRoom();
            s += room.descRoom(true);
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
      doorDir = NORTH;
      doorTo = 'livingArea';
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
// TODO: what if player wants to make fire?
// TODO: cobwebs as a hint!
// could be a good solution to get rid of the spider!
// but we need some wood (barn?)
// TODO: check desc for scenery
      desc = 'Enshrouded in desolation, the deserted living area is strewn with the detritus of time. A cold, moribund hearth lies in shadow, while the sinister visage of a mounted black wolf head surveys its dominion from the wall right of it. A doorway lies in every wall, yet only the eastern and southern ones retain doors.';
      wTo = 'bedroom';
      nTo = 'barn';
      eTo = 'kitchenDoor';
      // NOTE: sTo is a link

/**
INITIAL
An old longbow is affixed to the wall left of the fireplace.

LONGBOW
The longbow is fastened in place by some kind of mechanism.

MECHANISM
The iron clasps vanish seamlessly into the wall.

BLACK WOLF HEAD
A mounted ebony wolf's head casts a menacing glare upon you.

FIREPLACE
The hearth's stone lies dormant, devoid of warmth.

SEARCH FIREPLACE
There is nothing interesting on the outside.
**/
      addChild(new ClayMug(this));
      addChild(new KitchenDoor(this));
    }
}

private class KitchenDoor extends Door
{
  public var bucketMoved: Bool;
  public var bucketCrashed: Bool;
  public function new(parent: Obj)
    {
      super(parent);
      id = 'kitchenDoor';
      name = 'eastern door';
      linkedName = 'western door';
      names = [ 'east', 'eastern', 'door' ];
      linkedNames = [ 'west', 'western', 'door' ];
//      desc = 'Through the door crack, the neglected kitchen is partially visible.';
      doorDir = EAST;
      doorTo = 'kitchen';
      setAttr(SEARCHABLE);
      addChild(new DoorBucket(this));
      bucketMoved = false;
      bucketCrashed = false;
    }

// called when player finds bucket (from either side)
// NOTE: this is always called on origin (living area)
  public function bucketFound()
    {
      // origin
      setAttr(SEARCHED);
      var bucket = getChild('bucketDoor');
      if (bucket != null)
        bucket.unsetAttr(HIDDEN);
      // link
      linkedObj.unsetAttr(SEARCHABLE);
      var bucketLink = linkedObj.getChild('bucketDoor');
      if (bucketLink != null)
        bucketLink.unsetAttr(HIDDEN);
    }

// called when bucket is taken/removed or falls down
// NOTE: this is always called on origin (living area)
  public function bucketRemoved(crashed: Bool)
    {
// TODO: xp reward if not crashed
      // set flag and move bucket to room
      untyped bucketMoved = true;
      untyped linkedObj.bucketMoved = true;
      untyped bucketCrashed = crashed;
      untyped linkedObj.bucketCrashed = crashed;
      setAttr(OPEN);

      // remove linked door bucket
      var linkedBucket = linkedObj.getChild('bucketDoor');
      linkedBucket.destroy();

      // move to room
      var bucket = getChild('bucketDoor');
      bucket.moveTo(actor.getRoom());
    }

  override function whenClosedF()
    {
      if (bucketMoved)
        return TheName + ' is closed.';
      var s = TheName + ' is slightly ajar.';
      if (getRoom().id == 'kitchen' &&
          hasChild('bucketDoor'))
        s += ' There is a rusty bucket on top of it.';
      return s;
    }

  override function descChildren()
    { return ''; }

  override function descF()
    {
      if (hasAttr(OPEN))
        return TheName + ' is open.';
      if (bucketMoved)
        return TheName + ' is closed.';
      var s = TheName + ' is slightly open leaving a crack.';
      if (!bucketMoved)
        {
          var bucket = getChild('bucketDoor');
          if (bucket.hasAttr(HIDDEN))
            s += ' There is something on top of it.';
          else s += ' There is a rusty bucket on top of it.';
        }
      return s;
    }

  public override function after(): String
    {
      switch (state.action)
        {
          case OPEN:
            var bucket = getChild('bucketDoor');
            if (bucket != null)
              {
                var door: KitchenDoor = cast scene.findObject('kitchenDoor');
                door.bucketFound();
                door.bucketRemoved(true);
// TODO: sound
                return "**CLANG!** As you push the door open, the bucket on top of it crashes to the floor with a resounding clang.";
              }
            return super.after();
          case SEARCH:
            return 'Upon closely inspecting the door, you discover a bucket on top of it.';
          default:
            return super.after();
        }
    }
}

private class DoorBucket extends Item
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'bucketDoor';
      name = 'rusty bucket';
      names = [ 'rusty', 'bucket' ];
      setAttr(HIDDEN);
      setAttr(CONCEALED);
    }

  override function descF()
    {
      var door: KitchenDoor = cast scene.findObject('kitchenDoor');
      if (door.bucketCrashed)
        return 'The fallen bucket rests on the floor, a quiet reminder of its recent tumble.';
      else if (door.bucketMoved)
        return 'It is safely out of the way.';
      else return 'Perched precariously atop the door, the rust-covered bucket is bound to tumble down upon opening.';
    }

  public override function before()
    {
      switch (state.action)
        {
          case TAKE:
            var door: KitchenDoor = cast scene.findObject('kitchenDoor');
            if (door.bucketMoved)
              {
                p("It's useless.");
                return false;
              }
          default:
            return super.before();
        }
      return true;
    }

  override function during()
    {
      switch (action)
        {
          case TAKE:
            var door: KitchenDoor = cast scene.findObject('kitchenDoor');
            door.bucketRemoved(false);
          default:
            super.during();
        }
    }

  public override function after(): String
    {
      switch (state.action)
        {
// TODO: more verbs: push, remove, move, etc
          case TAKE:
            return 'With great caution, you remove the bucket from its perch atop the door and set it aside.';
          default:
            return super.after();
        }
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
      desc = "Filth and rubble litter the space. A grimy cauldron sits in the fireplace, a skeletal hand protruding ominously from it. A gaping trapdoor beckons from the northeast ceiling corner, while a passage with a tattered door leads north, and another door leads west.";
      nTo = 'storageArea';
      // NOTE: wTo is a link
      uTo = 'attic';

      addChild(new Barrel(this));
      addChild(new PileOfClothes(this));
      addChild(new PileOfClothesStains(this));
      addChild(new RippedBackpack(this));
/**
BUCKET
The door to the west is slightly ajar, and there is a bucket perched precariously on top of it.

CAULDRON
The cauldron brims with an assortment of bones, raising the chilling question: are they human?

BONES
The whitened bones serve as a warning, highlighting the perils that lie in wait for unwary adventurers.
**/
    }

  override function initialF()
    {
      var door: KitchenDoor = cast scene.findObject('kitchenDoor');
      door.bucketFound();
      return super.initialF();
    }
}

private class Barrel extends Obj
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'barrel';
      article = 'an';
      name = 'old barrel';
      names = [ 'old', 'barrel' ];
      initial = 'An aged barrel rests near the fireplace.';
    }
}

private class PileOfClothes extends Obj
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'pileOfClothes';
      name = 'pile of clothes';
      names = [ 'heap', 'pile', 'clothes', 'garments', 'rags', 'clothing' ];
      // NOTE: one for both
      describe = 'A heap of garments and a ripped backpack lie abandoned on the floor.';
      desc = 'A heap of modest, everyday clothing worn by commoners, some torn and others bearing dark stains.';
      addChild(new FeatheredHat(this));
      addChild(new SilkScarf(this));
      setAttr(SEARCHABLE);
    }

// remove children from desc
  override function describeF()
    {
      return describe;
    }

  public override function before()
    {
      switch (state.action)
        {
          case TAKE:
            p("You don't need any of these.");
            return false;
          default:
            return super.before();
        }
      return true;
    }

  public override function after(): String
    {
      switch (state.action)
        {
          case SEARCH:
            return 'In a pile of commoner garments, you discover an elegant hat adorned with colorful feathers and a luxurious silk scarf.';
          default:
            return super.after();
        }
    }
}

private class PileOfClothesStains extends Obj
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'stains';
      name = 'dark stains';
      names = [ 'dark', 'stains' ];
      desc = 'The deep-hued stains bear an unsettling resemblance to dried blood.';
      setAttr(CONCEALED);
    }

  public override function after(): String
    {
      switch (state.action)
        {
          case RUB, SMELL, TOUCH:
            return "That is indeed dried blood. It looks like it's a few days old.";
          default:
            return super.after();
        }
    }
}

private class RippedBackpack extends Item
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'rippedBackpack';
      name = 'torn backpack';
      names = [ 'ripped', 'torn', 'backpack', 'pack' ];
      desc = 'A completely torn backpack lies on the floor.';
      // NOTE: no initial
      addChild(new SilverMirror(this));
      addChild(new SilverComb(this));
      setAttr(SEARCHABLE);
    }

  public override function before()
    {
      switch (state.action)
        {
          case TAKE:
            p("It's all torn up and useless.");
            return false;
          case OPEN:
            p("It's already open.");
            return false;
          default:
            return super.before();
        }
      return true;
    }

  public override function after(): String
    {
      switch (state.action)
        {
          case SEARCH:
            return 'A frayed backpack stores ordinary items, revealing a petite silver mirror and a matching silver comb.';
          default:
            return super.after();
        }
    }
}

private class Bedroom extends Room
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'bedroom';
      name = 'Bedroom';
      desc = "A miasma of dust and stale air mingles with a pervasive musty odor. The lifeless form of a bird lies before an aged wardrobe, bereft of a door. The room's centerpiece, a fractured double-sized bed, is accompanied by a massive bear rug. A lone doorway to the east offers exit.";
      eTo = 'livingArea';
/**

WARDROBE
Aged and missing one door, the wardrobe houses a tattered cloak, a relic of bygone days.

BIRD:
The lifeless bird is covered in a peculiar golden dust. Curiously, the carcass shows no signs of physical damage.

BED:
Beneath the weight of an unseen force, the bed lies sundered in twain.

BEAR SKIN:
The dusty bear skin, a trophy of an immense and deadly creature, evokes a sense of awe and dread.

CLOAK
The ancient cloak, laden with a carpet of golden spores, emanates a noxious scent of decay. A tear in the fabric of its pocket reveals a glimpse of something metallic within.

SPORES
The peculiar spores, golden in color, emit a distinct and unpleasant scent of decay.
**/
    }
}

private class StorageArea extends Room
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'storageArea';
      name = 'Storage Area';
      desc = 'Numerous shelves stand burdened with the remnants of a once-thriving rural life. Broken tools, discarded horseshoes, and cracked earthenware pots serve as reminders of days long past. A heavy trapdoor leads downward, and a doorway to the south.';
      sTo = 'kitchen';
//      dTo = 'trapdoor';

/**
SEARCH SHELVES
A closer examination of the shelves uncovers a few bowstrings, a dusty oil flask and two jars of salted meat, preserved amidst the surrounding chaos.

TRAPDOOR
The wooden trapdoor, heavy and weathered, is secured by a rusty padlock, a testament to the secrets that lie beneath.

#TODO smell after opening
OPEN
The trapdoor opens revealing stone steps leading into the darkness.
#TODO listen

PADLOCK
The padlock is a rusted, yet sturdy relic, guarding its secret with unwavering determination.

SHELVES
The shelves display a jumble of farm relics, including tattered grain sacks, rusted tools, and crumbling leather harnesses. A thorough search would be needed to uncover anything useful.

The shelves are cluttered with various items that narrate the history of the farmhouse: tattered sacks of long-spoiled grains, rusted farming implements, and the crumbling remains of leather harnesses for horses or livestock.

**/
    }
}

private class Cellar extends Room
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'cellar';
      name = 'Cellar';
      desc = 'Within the shadowy depths of the cellar, echoes of rural existence envelop you: laden shelves brimming with sundries, timber crates, barrels, and bottles. The stench of decay permeates the air, as a macabre pile of bones lies in a corner. Stone steps lead upwards to the world above.';
//      uTo = 'trapdoor';
    }
}

/**
BONES
Every bone exhibits the telltale scars of relentless gnawing.

ZOMBIE
A shadowed figure shambles through the gloom, lamenting a single word: "Papa..."

SHELVES
Most shelf contents hold no value to you: worn tools, rusted utensils, and cracked pottery.

SEARCH SHELVES
Scouring the shelves, you uncover some usable snares.

CRATES/BOXES
Wooden boxes are haphazardly stacked in a corner.

SEARCH BOXES
Rifling through the crates, you unearth a small trove of animal pelts.

BARRELS
Some barrels appear to be filled with unknown contents.

SEARCH BARRELS
The barrels, upon closer inspection, are either empty or filled with spoiled goods.

BOTTLES
The bottles mostly contain cheap wine, vinegar, and other mundane liquids.

SEARCH BOTTLES
Upon further investigation, you discover a few bottles of quality wine.
**/

private class Attic extends Room
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'attic';
      name = 'Attic';
      desc = 'The attic, a haphazard and dusty space, is crammed with a jumble of household items, including messy stacks of extra bedding, disheveled clothing, and strewn baskets.';
      dTo = 'kitchen';

/**
SEARCH (GENERIC)
You find nothing useful searching theName.
TheName holds nothing of interest.

Searching through theName, you find list.

BEDDING
The disordered piles of extra bedding are scattered around the attic.

CLOTHING
Tangled peasant garments are strewn about the attic.

SEARCH CLOTHING -> FIGURINE
The animal figurine is a small, intricately carved wooden fox with a bushy tail. It has minor value.

BASKETS
Most of the baskets are empty.

BASKETS -> NECKLACE
The necklace of beads features various colorful shapes made from polished glass. It has minor value.
**/
    }
}

private class Barn extends Room
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'barn';
      name = 'Decrepit Barn';
      desc = 'The dusty barn creaks softly in the wind with its weathered wooden beams and walls. Heaps of decaying hay blanket the ground around a horse skeleton. Rust-covered tools lay haphazardly near the walls. There is a open doorway leading south into the house. A door leads outside north.';
      sTo = 'livingArea';
      cantGo = 'The farmhouse waits for you to unravel its hidden secrets.';
    }
}
/**
TODO CANTGO

INITIAL
A neglected, rusty scythe lies on the ground.

TOOLS
Rusty tools, including a hammer, pliers, and an old pitchfork, are scattered haphazardly near the walls.

TAKE
The tools are useless by now.

SEARCH HAY
The moldy hay holds nothing of interest.
**/

