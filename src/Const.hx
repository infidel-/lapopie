// game constants

import js.Browser;

class Const
{
// these keywords are ignored by the command parser
  public static var ignoredKeywords = [
    '', // empty word created by whitespace in the middle of the command
    'a',
    'at',
    'in',
    'is',
    'on',
    'the',
  ];

// these keywords are ignored by the command parser
  public static var ignoredCombatKeywords = [
    '', // empty word created by whitespace in the middle of the command
    'at',
    'in',
    'is',
    'on',
    'the',
  ];


// roll fail strings
  public static var stringsFail: Map<String, Array<String>> = [
    'spotHidden' => [
      'You fail to notice anything special.',
      'Nothing catches your eye.',
      'There is nothing that attracts your attention.',
    ],
    'strength' => [
      'Your strength fails you.',
    ],

    // ========= standard actions =============
    'get' => [
      'You do not need to pick that up.',
    ],
    'open' => [
      'You do not need to open that.',
    ],
    'unlock' => [
      'You do not need to unlock that.',
    ],
  ];


// common string
  public static var strings: Map<String, Array<String>> = [
    'nothingImportant' => [
      'There is nothing important here.',
      'You do not see anything important here.',
    ]
  ];

// canned strings

// trace call stack for debug
  public static inline function traceStack()
    {
      trace(haxe.CallStack.toString(haxe.CallStack.callStack()));
    }


  public static function dice(x: Int, y: Int)
    {
      var r = 0;
      for (i in 0...x)
        r += 1 + Std.random(y);
      return r;
    }

// replace special symbols with HTML
  public static function replaceSpecial(s: String): String
    {
      s = StringTools.replace(s, '<', '&lt;');
      s = StringTools.replace(s, '>', '&gt;');
      return s;
    }

// convert a-z into a number
// returns -1 on error
  public static function letterToNum(s: String): Int
    {
      var group = s.charCodeAt(0);
      // A-Z
      if (group >= 65 && group <= 90)
        return group - 65;
      // a-z
      else if (group >= 97 && group <= 122)
        return group - 97;
      else return -1;
    }

// standard potion drinking msg
// amount - 1: full, 2: dose
  public static function potionDrinkMsg(char: Character, item: Item,
      dose: Int, isKnown: Bool): String
    {
      var potion = item.potion;
      var potionName = (isKnown ?
        potion.name.toLowerCase() :
        'potion of some kind');
      var doseStr = '';
      if (dose == 1)
        doseStr = ' a full ';
      else if (dose == 2)
        {
          if (potion.doses == 2)
            doseStr = ' a half of a ';
          else if (potion.doses == 3)
            doseStr = ' a third of a ';

          if (item.potionDoses == 1)
            doseStr = ' the last of a ';
        }

      return char.nameCapped + ' drink' +
        (char.isPlayer ? '' : 's') + doseStr + ' ' + potionName;
    }

// get CSS variable
  public static inline function getVar(s: String): String
    {
      return Browser.window.getComputedStyle(
        Browser.document.documentElement).getPropertyValue(s);
    }

// get CSS variable as int
  public static inline function getVarInt(s: String): Int
    {
      return Std.parseInt(getVar(s));
    }

// set CSS variable
  public static inline function setVar(key: String, val: String)
    {
      return Browser.document.documentElement.style.setProperty(key, val);
    }
}

