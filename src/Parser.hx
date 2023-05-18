// parser and tokenizer
class Parser
{
  var game: Game;
  public var state: ParserState;
  // calculate once on start
  var verbs: Map<String, List<_VerbInfo>>;
  var dirs: Map<String, _CompassDirection>;
  // calculate on each run
  var scope: _Scope;

  public function new(g: Game)
    {
      game = g;
      state = new ParserState(game, this);
      dirs = [
        'north' => NORTH,
        'n' => NORTH,
        'south' => SOUTH,
        's' => SOUTH,
        'west' => WEST,
        'w' => WEST,
        'east' => EAST,
        'e' => EAST,
        'northeast' => NE,
        'ne' => NE,
        'northwest' => NW,
        'nw' => NW,
        'southeast' => SE,
        'se' => SE,
        'southwest' => SW,
        'sw' => SW,
        'up' => UP,
        'down' => DOWN,
      ];
      scope = null;

      // form a map of verb -> action from first token
      verbs = new Map();
      for (info in _Verbs.infos)
        {
          var token = info.tokens[0];
          if (token.type == WORDS)
            for (w in token.words)
              addVerb(w, info);
          else if (token.type == WORD)
            addVerb(token.word, info);
        }
//      trace(verbs);
    }

// add verb to map
  function addVerb(word: String, verb: _VerbInfo)
    {
      var list = verbs[word];
      if (list == null)
        {
          list = new List();
          verbs[word] = list;
        }
      list.add(verb);
    }

// split text into words and then tokens
// NOTE: returns true on success, false on failure
  public function run(text: String): Bool
    {
      // clear current state
      state.clear();
      // form scope
      scope = getScope();

      // parse input into words
      var tmp = text.split(' ');
      var words = [];
      for (w in tmp)
        if (w != '')
          words.push(w);

      // go through words forming a line of tokens
      state.tokens = [];
      for (w in words)
        {
          // check for verbs
          if (verbs[w] != null)
            {
              // could be a dir too (s - search/south)
              if (dirs[w] != null)
                state.tokens.push({
                  type: VERBORDIR,
                  word: w,
                  dir: dirs[w],
                });
              else state.tokens.push({
                type: VERB,
                word: w,
              });
            }
          // check for scoped nouns
          else if (scope[w] != null)
            {
              // could be a noun too (south door)
              /*if (dirs[w] != null)
                state.tokens.push({
                  type: NOUNORDIR,
                  word: w,
                  dir: dirs[w],
                });
              else*/ state.tokens.push({
                  type: NOUN,
                  word: w,
                });
            }
          // check for directions
          else if (dirs[w] != null)
            {
              // could be a word too (pick up rock)
              state.tokens.push({
                type: WORDORDIR,
                word: w,
                dir: dirs[w],
              });
            }
          // for now just make a word out of it
          else state.tokens.push({
            type: WORD,
            word: w,
          });
        }

      // special case - just direction
      if (state.tokens.length == 1)
        {
          var t = state.tokens[0];
          if (Lambda.has([ DIRECTION, WORDORDIR, VERBORDIR ], t.type))
            {
              state.action = GODIR;
              state.dir = t.dir;
              state.actor = game.player; // for now
              return true; 
            }
        }

      // first token must be a verb (for now?)
      if (state.tokens[0].type != VERB &&
          state.tokens[0].type != VERBORDIR)
        {
          game.console.debug('' + state.tokens);
          error('Commands must start with a verb.');
          return false;
        }

      // squish noun lines and check for errors
      if (!squishNouns())
        return false;
//      trace(state.tokens);

      // loop through command templates finding one that works
      var infos = verbs[state.tokens[0].word];
      for (info in infos)
        {
          // should be the same length
          if (info.tokens.length !=
              state.tokens.length)
            continue;
          var ok = true;
          for (i in 0...info.tokens.length)
            {
              var itoken = info.tokens[i];
              var stoken = state.tokens[i];
              if (itoken.type == WORD)
                {
                  if (stoken.type != WORDORDIR &&
                      stoken.type != WORD &&
                      stoken.type != VERBORDIR &&
                      stoken.type != VERB)
                    {
                      ok = false;
                      break;
                    }
                  if (stoken.word != itoken.word)
                    {
                      ok = false;
                      break;
                    }
                }
              else if (itoken.type == WORDS)
                {
                  if (stoken.type != WORD &&
                      stoken.type != VERB &&
                      stoken.type != VERBORDIR)
                    {
                      ok = false;
                      break;
                    }
                  if (itoken.words.indexOf(stoken.word) < 0)
                    {
                      ok = false;
                      break;
                    }
                }
              else if (itoken.type == NOUN)
                {
/*
                  if (stoken.type == NOUNORDIR)
                    {
                      stoken.type = OBJECT;
                      // hack: grab first one
                      stoken.obj = scope[stoken.word].first();
                      stoken.word = null;
                    }*/
                  if (stoken.type != OBJECT)
                    {
                      ok = false;
                      break;
                    }
                }
              else if (itoken.type == DIRECTION)
                {
                  if (stoken.type != DIRECTION &&
                      stoken.type != WORDORDIR &&
                      stoken.type != VERBORDIR)
                    {
                      ok = false;
                      break;
                    }
                }
              // always success
              else if (itoken.type == WORDANY)
                1;
              else
                {
                  error('No checks for ' + itoken.type + '.');
                }
            }
          if (!ok)
            continue;

          // info tokens are the same as state tokens
          // update state with info
          state.action = info.action;
          state.actor = game.player; // for now
          for (token in state.tokens)
            if (token.type == OBJECT)
              {
                if (state.first == null)
                  state.first = token.obj;
                else state.second = token.obj;
              }
            else if (token.type == DIRECTION)
              state.dir = token.dir;
          return true;
        }
      // no commands were found
      game.console.debug('' + state.tokens);
      error('I didn’t understand that sentence.');
      return false;
    }

// squish lines of nouns and check for related errors
  function squishNouns(): Bool
    {
      var tokens1 = state.tokens;
      // try to squish lines of nouns into one
      var tokens: Array<_VerbToken> = [];
      var i = 0;
      while (i < tokens1.length)
        {
          // find line of nouns
          var token = tokens1[i];
          if (token.type != NOUN)
            {
              tokens.push(token);
              i++;
              continue;
            }
          var line = [ token ];
          for (j in (i + 1)...tokens1.length)
            if (tokens1[j].type == NOUN)
              line.push(tokens1[j]);

          // multiple objects
          var list = null;
          if (line.length > 1)
            list = squishLineNouns(line);
          else list = scope[token.word];
          if (list.length > 1)
            {
              var arr = [];
              for (o in list)
                arr.push(o.name);
              error('You can’t use multiple objects with that verb: ' + arr.join(', ') + '.');
              return false;
            }
          else if (list.length == 0)
            {
              var uniq = new Map<String, Bool>();
              for (token in line)
                {
                  var list = scope[token.word];
                  for (o in list)
                    uniq[o.name] = true;
                }
              var arr = [];
              for (k in uniq.keys())
                arr.push(k);
              error('You can’t use multiple objects with that verb: ' + arr.join(', ') + '.');
              return false;
            }
          tokens.push({
            type: OBJECT,
            obj: list.first(),
          });
          i += line.length;
        }
      state.tokens = tokens;
      return true;
    }

// try to squish list of sorta-same objects into one
  function squishLineNouns(list: Array<_VerbToken>): List<Obj>
    {
      // find object that appears in all lists
      var map = new Map<Obj, Int>();
      for (token in list)
        {
          var list = scope[token.word];
          for (obj in list)
            if (map[obj] == null)
              map[obj] = 1;
            else map[obj]++;
        }
//      trace(map);
      // get object that appears in all
      var list2 = new List();
      for (obj => cnt in map)
        {
          if (cnt != list.length)
            continue;
          list2.add(obj);
        }

      return list2;
    }

// print error
  inline function error(s: String)
    {
      game.console.print(s);
    }

// form a map of name -> object for all objects around player party
  function getScope(): _Scope
    {
      // objects in a room where the party is
      var scope = new Map();
      var o = game.party.parent; 
      for (ch in o.children)
        {
          for (name in ch.names)
            addName(scope, name, ch);
          // children of searched items
          if (ch.hasAttr(SEARCHED))
            for (subch in ch.children)
              if (!ch.hasAttr(CONCEALED))
                {
                  for (name in subch.names)
                    addName(scope, name, subch);
                }
        }
//      trace(scope);
      // player inventory
      for (ch in game.player.children)
        for (name in ch.names)
          addName(scope, name, ch);

      return scope;
    }

// push to list of names
  function addName(scope: _Scope, name, obj)
    {
      var list = scope[name];
      if (list == null)
        {
          list = new List();
          scope[name] = list;
        }
      list.add(obj);
    }

}

typedef _Scope = Map<String, List<Obj>>;
typedef _VerbInfo = {
  var action: _Action;
  var tokens: Array<_VerbToken>;
};
typedef _VerbToken = {
  var type: _TokenType;
  @:optional var word: String;
  @:optional var words: Array<String>;
  @:optional var obj: Obj;
  @:optional var dir: _CompassDirection;
};
enum _TokenType {
  DIRECTION;
  NOUN;
  WORD;
  WORDANY;
  WORDORDIR;
  WORDS;
  VERBORDIR;
  // after parsing
  OBJECT;
  VERB;
}

