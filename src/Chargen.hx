// character generation state

class Chargen
{
  var game: Game;
  public var state: _ChargenState;
  var method: Int;
  var stats: Stats;

  public function new(g: Game)
    {
      game = g;
      state = CHARGEN_METHOD;
    }

// run chargen command
  public function runCommand(cmd: String, tokens: Array<String>): Int
    {
      if (state == CHARGEN_METHOD)
        {
          if (cmd.length > 1)
            {
              p('Select method: a-c.');
              return -1;
            }
          method = Const.letterToNum(cmd);
          if (method < 0 || method > 2)
            {
              p('Select method: a-c.');
              return -1;
            }
          state = CHARGEN_ABILITIES;
          roll();
          print();
          return 1;
        }
      else if (state == CHARGEN_ABILITIES)
        {
          if (cmd == 'reroll' || cmd == 'roll' || cmd == 'r')
            {
              roll();
              print();
              return 1;
            }
          else if (cmd == 'swap' || cmd == 's')
            {
              if (method != METHOD_3D6 && method != METHOD_4D6) 
                {
                  p('You cannot swap scores in this generation method.');
                  return -1;
                }
              if (tokens.length != 2 ||
                  tokens[0].length > 1 ||
                  tokens[1].length > 1)
                {
                  p('Usage: swap &lt;a-f&gt; &lt;a-f&gt;');
                  return -1;
                }
              var from = Const.letterToNum(tokens[0]);
              var to = Const.letterToNum(tokens[1]);
              if (from < 0 || from > 5 || to < 0 || to > 5)
                {
                  p('Usage: swap &lt;a-f&gt; &lt;a-f&gt;');
                  return -1;
                }
              if (from == to)
                {
                  p('Abilities need to be different.');
                  return -1;
                }
              var fromVal = stats.get(from);
              var toVal = stats.get(to);
              stats.set(from, toVal);
              stats.set(to, fromVal);
              print();
              return 1;
            }
          else if (cmd == 'start')
            {
              var minStats = _TablesCleric.minStats;
              var ret = stats.checkMin(minStats);
              if (ret != '')
                {
                  p(ret);
                  return -1;
                }
              game.start(stats);
              return 1;
            }
        }
      
      return 0;
    }

// print current state
  public function print()
    {
      if (state == CHARGEN_METHOD)
        {
          p('Select your ability scores generation method:\n' +
            'a) Roll 3d6 for all ability scores in order (hard)\n' +
            'b) Roll six 3d6, can swap scores (normal)\n' +
            'c) Roll 4d6 and drop lowest for each score, can swap (easy)');
        }
      else if (state == CHARGEN_ABILITIES)
        {
          var strStats = _TablesClass.instance.strStats[stats.str * 100];
          var dexStats = _TablesClass.instance.dexStats[stats.dex];
          var conStats = _TablesClass.instance.conStats[stats.con];
          var wisStats = _TablesCleric.instance.wisStats[stats.wis];
          if (wisStats == null)
            wisStats = {
              bonusSpells: [ 0, 0 ],
              spellFailureChance: 100,
            };
          var chaStats = _TablesClass.instance.chaStats[stats.cha];
          var minStats = _TablesCleric.minStats;
          var bonusSpells = [ 0, 0 ];
          for (i in 0...2)
            bonusSpells[i] = wisStats.bonusSpells[i];
          p('Ability scores:\n' +
            'a) ' + stats.getChargenString(0, minStats) +
            ' (melee to hit: ' + strStats.toHitBonus +
            ', to damage: ' + strStats.toDamageBonus +
            ', encumbrance adj: ' + strStats.encAdj +
            ')\n' +

            'b) ' + stats.getChargenString(1, minStats) +
            ' (surprise bonus: ' + dexStats.surpriseBonus +
            ', missile to hit: ' + dexStats.missileBonusToHit +
            ', AC adj: ' + dexStats.acAdj + ')\n' +

            'c) ' + stats.getChargenString(2, minStats) +
            ' (HP bonus: ' + conStats.hpBonus +
            ')\n' +

            'd) ' + stats.getChargenString(3, minStats) +
            ' (dump stat)\n' +

            'e) ' + stats.getChargenString(4, minStats) +
            ' (bonus spells: ' + bonusSpells +
            ', chance of spell failure: ' + wisStats.spellFailureChance +
            '%)\n' +

            'f) ' + stats.getChargenString(5, minStats) +
            ' (max henchmen: ' + chaStats.maxHenchmen +
            ', loyalty bonus: ' + chaStats.loyaltyBonus +
            '%, reaction bonus: ' + chaStats.reactionBonus +
            '%)');
          p('You can use roll (r) command to reroll' +
            ((method == METHOD_3D6 || method == METHOD_4D6) ?
             ', and swap (s) command to swap any two abilities.' : '.') +
            ' Type "start" to start the game.');
        }
    }

// reroll abilities according to chosen method
  function roll()
    {
      if (method == METHOD_RANDOM ||
          method == METHOD_3D6)
        {
          stats = {
            str: Const.dice(3,6),
            str18: -1,
            dex: Const.dice(3,6),
            con: Const.dice(3,6),
            int: Const.dice(3,6),
            cha: Const.dice(3,6),
            wis: Const.dice(3,6),
          };
        }
      else if (method == METHOD_4D6)
        {
          stats = {
            str: 0,
            str18: -1,
            dex: 0,
            con: 0,
            int: 0,
            cha: 0,
            wis: 0,
          };
          for (i in 0...6)
            {
              var rolls = new List();
              for (x in 0...4)
                rolls.push(Const.dice(1, 6));
              var min = 1000;
              for (r in rolls)
                if (r < min)
                  min = r;
              rolls.remove(min);
              var sum = 0;
              for (r in rolls)
                sum += r;
              stats.set(i, sum);
            }
        }
    }

  inline function p(s: String)
    {
      game.console.print(s);
    }

  static var METHOD_RANDOM = 0;
  static var METHOD_3D6 = 1;
  static var METHOD_4D6 = 2;
}

@:enum
abstract _ChargenState(String) {
  var CHARGEN_METHOD = 'CHARGEN_METHOD';
  var CHARGEN_ABILITIES = 'CHARGEN_ABILITIES';
}

