// DEMO - Forest Road

package infos;

class ForestRoadDemo extends Scene
{
  public function new(g: Game)
    {
      super(g);

      // =locations
      locations = [
        {
          id: 'road',
          game: game,
          name: 'In the camp',
          note: 'You are in the temporary camp you\'ve made to rest.',
          actions: [],
          objects: [
            'fire' => {
              id: 'fire',
              names: [ 'fire', 'flame' ],
              locationNote: 'There is a cozy fire burning here.',
              note: 'The flames dance around giving off warmth and light.',
              actions: [
/*
                {
                  names: [ 'ring', 'push' ],
                  note: "You can't hear the sound from here but soon the front door opens and a man comes up to the gates. He must be the butler.",
                  result: {
                    type: RESULT_CHAT,
                    info: 'butlerThorston',
                  }
                }
*/
              ]
            },
          ],
        },
      ];
      startingLocation = locations[0];

      // =events
      events = [
        new DogsAttackDemo(game),
      ];
    }
}

class DogsAttackDemo extends Event
{
  public function new(g: Game)
    {
      super(g);
      id = 'dogsAttack';
      name = 'Dogs attack';
    }

  public override function turn(): _EventResult
    {
      // getting closer
      if (state == 0)
        {
          state++;
          return EVENT_CONTINUE;
        }
      else if (state <= 3)
        {
          var lines = [
            '',
            'The distant howling seems to be getting closer.',
            'The howling is definitely closer now.',
            'Soon they will be here.'
          ];
          print(lines[state]);
          state++;
          return EVENT_CONTINUE;
        }

      // attack
      print('The pack of wild dogs trots out of the forest!');
      game.combat.addMonsterGroup([
        'wildDog',
        'wildDog',
        'wildDog',
      ], 100);
      game.combat.start();
      return EVENT_STOP;
    }
}
