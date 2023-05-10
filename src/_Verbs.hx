// verb templates that parser recognizes as actions
import Parser;

class _Verbs
{
  public static var infos: Array<_VerbInfo> = [
/**
Verb 'close' 'cover' 'shut'
    * 'off' noun  -> SwitchOff;
**/
    // close X
    {
      action: CLOSE,
      tokens: [
        {
          type: WORDS,
          words: [ 'close', 'cover', 'shut' ],
        },
        {
          type: NOUN,
        },
      ],
    },
    // cover up X
    {
      action: CLOSE,
      tokens: [
        {
          type: WORDS,
          words: [ 'close', 'cover', 'shut' ],
        },
        {
          type: WORD,
          word: 'up',
        },
        {
          type: NOUN,
        },
      ],
    },
/**
Verb 'drop' 'discard'
    * multiexcept 'in'/'into'/'down' noun -> Insert
    * multiexcept 'on'/'onto' noun -> PutOn;
**/
    // drop X
    {
      action: DROP,
      tokens: [
        {
          type: WORDS,
          words: [ 'drop', 'discard' ],
        },
        // TODO: multiheld
        {
          type: NOUN,
        },
      ],
    },
/**
Verb 'get'
    * 'out'/'off'/'up' 'of'/'from' noun -> Exit
    * 'in'/'into'/'on'/'onto' noun -> Enter
    * 'off' noun -> GetOff
    * multiinside 'from'/'off' noun -> Remove;
**/
    // get X
    {
      action: TAKE,
      tokens: [
        {
          type: WORDS,
          words: [ 'get', 'grab' ],
        },
        // TODO: multi
        {
          type: NOUN,
        },
      ],
    },
/**

Verb 'go' 'run' 'walk'
    *        -> VagueGo
    * 'out'/'outside'   -> Exit
    * 'in'/'inside'     -> GoIn

Verb 'enter' 'cross'
    *        -> GoIn

**/
    // go
    {
      action: GO,
      tokens: [
        {
          type: WORDS,
          words: [ 'go', 'run', 'walk' ],
        },
        {
          type: WORDS,
          words: [ 'into', 'in', 'inside', 'through' ],
        },
        {
          type: NOUN,
        },
      ],
    },
    // go direction
    {
      action: GODIR,
      tokens: [
        {
          type: WORDS,
          words: [ 'go', 'run', 'walk' ],
        },
        {
          type: DIRECTION,
        },
      ],
    },
    // enter
    {
      action: ENTER,
      tokens: [
        {
          type: WORDS,
          words: [ 'enter', 'cross', 'go', 'run', 'walk' ],
        },
        {
          type: NOUN,
        },
      ],
    },
    // examine X
    {
      action: EXAMINE,
      tokens: [
        {
          type: WORDS,
          words: [ 'examine', 'x', 'check', 'describe', 'watch' ],
        },
        {
          type: NOUN,
        },
      ],
    },
/**
Verb 'inventory' 'inv' 'i//'
    * 'tall' -> InvTall
    * 'wide' -> InvWide;
**/
    // inventory
    {
      action: INVENTORY,
      tokens: [
        {
          type: WORDS,
          words: [ 'inventory', 'inv', 'i' ],
        },
      ],
    },
/*
look
Verb 'look' 'l//'
    * 'under' noun          -> LookUnder
    * 'up' topic 'in' noun  -> Consult
    * noun=ADirection       -> Examine
    * 'to' noun=ADirection  -> Examine;
*/
    // look
    {
      action: LOOK,
      tokens: [
        {
          type: WORDS,
          words: [ 'look', 'l' ],
        },
      ],
    },
    // look at X
    {
      action: EXAMINE,
      tokens: [
        {
          type: WORDS,
          words: [ 'look', 'l' ],
        },
        {
          type: WORD,
          word: 'at',
        },
        {
          type: NOUN,
        },
      ],
    },
    // look into X
    {
      action: SEARCH,
      tokens: [
        {
          type: WORDS,
          words: [ 'look', 'l' ],
        },
        {
          type: WORDS,
          words: [ 'inside', 'in', 'into', 'through', 'on' ],
        },
        {
          type: NOUN,
        },
      ],
    },
    // open X
    {
      action: OPEN,
      tokens: [
        {
          type: WORDS,
          words: [ 'open', 'uncover', 'undo', 'unwrap' ],
        },
        {
          type: NOUN,
        },
      ],
    },
    // open X with Y
    {
      action: UNLOCK,
      tokens: [
        {
          type: WORDS,
          words: [ 'open', 'uncover', 'undo', 'unwrap' ],
        },
        {
          type: NOUN,
        },
        {
          type: WORD,
          word: 'with',
        },
        {
          type: NOUN,
        },
      ],
    },
    // peel X
    {
      action: TAKE,
      tokens: [
        {
          type: WORD,
          word: 'peel',
        },
        {
          type: NOUN,
        },
      ],
    },
    // peel off X
    {
      action: TAKE,
      tokens: [
        {
          type: WORD,
          word: 'peel',
        },
        {
          type: WORD,
          word: 'off',
        },
        {
          type: NOUN,
        },
      ],
    },
    // pick up X
    {
      action: TAKE,
      tokens: [
        {
          type: WORD,
          word: 'pick',
        },
        {
          type: WORD,
          word: 'up',
        },
        // TODO: multi
        {
          type: NOUN,
        },
      ],
    },
    // pick X up
    {
      action: TAKE,
      tokens: [
        {
          type: WORD,
          word: 'pick',
        },
        // TODO: multi
        {
          type: NOUN,
        },
        {
          type: WORD,
          word: 'up',
        },
      ],
    },
/**
Verb 'put'
    * multiexcept 'in'/'inside'/'into' noun -> Insert
    * multiexcept 'on'/'onto' noun -> PutOn
    * 'on' multiheld -> Wear
**/
    // put down X
    {
      action: DROP, 
      tokens: [
        {
          type: WORD,
          word: 'put',
        },
        {
          type: WORD,
          word: 'down',
        },
        // TODO: multiheld
        {
          type: NOUN,
        },
      ],
    },
    // put X down
    {
      action: DROP,
      tokens: [
        {
          type: WORD,
          word: 'put',
        },
        // TODO: multiheld
        {
          type: NOUN,
        },
        {
          type: WORD,
          word: 'down',
        },
      ],
    },
/**
Verb 'take'
    * 'off' multiheld -> Disrobe
    * multiinside 'from'/'off' noun -> Remove
    * 'inventory' -> Inv;
**/
    // take X
    {
      action: TAKE,
      tokens: [
        {
          type: WORD,
          word: 'take',
        },
        // TODO: multi
        {
          type: NOUN,
        },
      ],
    },
  ];
}

