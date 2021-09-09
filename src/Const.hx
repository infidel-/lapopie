// game constants

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
}

