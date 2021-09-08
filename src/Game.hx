@:expose
class Game
{
  public var console: Console;
  public var scene: Scene;
  public var location: Location;
  public var combat: Combat;
  public var player: Character;
  public var party: Array<Character>;
  public var extendedInfo: Bool;
  public var debug: {
    var evaluate: Bool;
    var failRoll: Bool;
  }
  public var state(get, set): _GameState;
  var _state: _GameState;
  public var isOver: Bool;

  public function new()
    {
      isOver = false;
      _state = STATE_LOCATION;
      location = null;
      extendedInfo = true;
      combat = new Combat(this);
      debug = {
        evaluate: false,
        failRoll: false,
      };
      party = [];

      // ============== DEMO SETUP ================
      // party
      player = new Character(this, CLASS_CLERIC, {
        str: 6 + Const.dice(2,6),
        str18: 0,
        dex: 6 + Const.dice(2,6),
        con: 6 + Const.dice(2,6),
        int: 6 + Const.dice(2,6),
        cha: 6 + Const.dice(2,6),
        wiz: 6 + Const.dice(2,6),
      });
      player.name = 'you';
      player.nameCapped = 'You';
      player.isPlayer = true;
      player.giveAndWearArmor('chain');
      player.giveAndWearMeleeWeapon('staff');
      party.push(player);
      var jean = new Character(this, CLASS_FIGHTER, {
        str: 6 + Const.dice(2,6),
        str18: 0,
        dex: 6 + Const.dice(2,6),
        con: 6 + Const.dice(2,6),
        int: 6 + Const.dice(2,6),
        cha: 6 + Const.dice(2,6),
        wiz: 6 + Const.dice(2,6),
      });
      jean.name = 'Jean';
      jean.nameCapped = 'Jean';
      jean.giveAndWearArmor('studded');
      jean.giveAndWearMeleeWeapon('club');
      party.push(jean);
      console = new Console(this);

      // temp start
      console.print('### Welcome to Lapopie DEMO.');
      console.printNarrative("The dusk came over the Rez forest. You and your companion were settling in for an evening by the fire near the road leading to Lapopie. But then you've heard a distant howling from somewhere in the thick woods...");
      scene = new infos.ForestRoadDemo(this);
      console.runCommand('stats');
      scene.enter();

      // DEBUG: auto commands
      for (i in 0...4)
        console.runCommand('z');
//      scene.moveTo('reflection');
    }

// time passing
  public function turn()
    {
      // scene events tick
      scene.turn();
    }

// finish game
  public function finish(res: String)
    {
      isOver = true;
      if (res == 'loseHP')
        console.printNarrative('Bleeding from your wounds, you lose consciousness never to wake up...');
      console.print('### GAME OVER');
    }


// get state
  function get_state()
    {
      return _state;
    }

// set state
  function set_state(st: _GameState)
    {
      _state = st;
      console.debug('Game state: ' + _state);
      return st;
    }


  static var inst: Game;
  static function main()
    {
      inst = new Game();
    }
}
