import items.*;
import items.Foodstuff;

@:expose
class Game
{
//  public var chargen: Chargen;
//  public var options: Options;
  public var console: Console;
  public var root: Obj;
  public var scene: Scene;
  public var debugCommands: DebugCommands;
//  public var location: Location;
//  public var combat: Combat;
  public var party: Party;
  public var player: Character;
//  public var party: Array<Character>;
  public var parserState: ParserState;
  public var parser: Parser;
  public var extendedInfo: Bool;
  public var debug: {
    var initiative: Bool;
  }
  public var state(get, set): _GameState;
  var _state: _GameState;
  public var isOver: Bool;

  public function new()
    {
      isOver = false;
      _state = STATE_CHARGEN;
//      location = null;
      parser = new Parser(this);
      parserState = parser.state;
      extendedInfo = true;
//      options = new Options(this);
//      combat = new Combat(this);
//      chargen = new Chargen(this);
      debugCommands = new DebugCommands(this);
      debug = {
        initiative: false,
      };
//      party = [];
      console = new Console(this);
      console.print('### Welcome to LaPopie DEMO 2.');
//      console.print('Let\'s start with generating your character.');
//      chargen.print();

      // DEBUG: auto chargen commands
/*#if mydebug
      console.runCommand('b');
      while (@:privateAccess chargen.stats.checkMin(_TablesCleric.minStats) != '')
        console.runCommand('r');
      console.runCommand('start');
#end*/
      root = new Obj(null);
      root.type = 'root';
      root.id = 'root';
      root.name = 'Root object';
      @:privateAccess root.game = this;
    }

// start new game (after chargen is over)
  public function start()//playerStats: Stats)
    {
      state = STATE_LOCATION;
      scene = new scenes.AbandonedFarmhouse(root);
      scene.init();
      party = new Party(root);
      party.id = 'player';
      party.name = 'Your party';
      party.setAttr(CONCEALED);
      player = new Character(party);
      player.setAttr(CONCEALED);
      player.addChild(new items.Apple(player));
      party.addChild(player);
/*
      // ============== DEMO SETUP ================
      // player
      player = new Character(this, CLASS_CLERIC, playerStats);
      player.name = 'you';
      player.nameCapped = 'You';
      player.isPlayer = true;
      player.giveItem(ITEM_ARMOR, 'chain', true);
//      player.giveItem(ITEM_WEAPON, 'staff', true);
//      player.giveItem(ITEM_WEAPON, 'sling', true);
      player.giveItem(ITEM_ARMOR, 'shieldMedium', true);
      player.giveItem(ITEM_WEAPON, 'heavyMace', true);
      player.giveItem(ITEM_POTION, 'healing', false);
      player.giveItem(ITEM_POTION, 'healing', false);
      player.giveItem(ITEM_POTION, 'extraHealing', false);
      //player.giveItem(ITEM_WEAPON, 'shortBow', true);
      party.push(player);

      // jean
      var jean = new Character(this, CLASS_FIGHTER, {
        str: 6 + Const.dice(2,6),
        str18: 0,
        dex: 6 + Const.dice(2,6),
        con: 6 + Const.dice(2,6),
        int: 6 + Const.dice(2,6),
        cha: 6 + Const.dice(2,6),
        wis: 6 + Const.dice(2,6),
      });
      jean.name = 'Jean';
      jean.nameCapped = 'Jean';
      jean.giveItem(ITEM_ARMOR, 'studded', true);
      jean.giveItem(ITEM_WEAPON, 'club', true);
      party.push(jean);

      // temp start
      console.runCommand('stats');
*/
      var room = scene.getChild('front');
      party.moveTo(room);
//      console.print('_Note: You can only "wait" on this scene so far._');
//      console.print('<u>Hint: Use "help" command.</u>');

#if mydebug
/*
      // DEBUG: auto commands
//      console.runCommand('dbg init');
      for (i in 0...4)
        console.runCommand('z');
//      scene.moveTo('reflection');
*/
      console.runCommand('open door');
//      console.runCommand('n');
      console.runCommand('dbg move kitchen');
#end
    }

// time passing
  public function turn()
    {
      // scene events tick
//      scene.turn();
    }

// finish game
  public function finish(res: String)
    {
      isOver = true;
      if (res == 'loseHP')
        console.dm('Bleeding from your wounds, you lose consciousness never to wake up...');
      console.print('### GAME OVER');
    }

// print todo string
  public function todo(s: String)
    {
      console.print('<span class=todo>TODO ' + s + '</span>');
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
//      _ItemsTables.fixWeapons();
      inst = new Game();
      inst.start();
    }
}
