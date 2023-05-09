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
          type: WORD_ANY,
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
          type: WORD_ANY,
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
          type: WORD,
          word: 'get',
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
          type: WORD_ANY,
          words: [ 'go', 'run', 'walk' ],
        },
        {
          type: WORD_ANY,
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
          type: WORD_ANY,
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
          type: WORD_ANY,
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
          type: WORD_ANY,
          words: [ 'examine', 'x', 'check', 'describe', 'watch' ],
        },
        {
          type: NOUN,
        },
      ],
    },
/*
look
Verb 'look' 'l//'
    * 'inside'/'in'/'into'/'through'/'on' noun  -> Search
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
          type: WORD_ANY,
          words: [ 'look', 'l' ],
        },
      ],
    },
    // look at X
    {
      action: EXAMINE,
      tokens: [
        {
          type: WORD_ANY,
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
    // open X
    {
      action: OPEN,
      tokens: [
        {
          type: WORD_ANY,
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
          type: WORD_ANY,
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

