// game options

class Options
{
  var game: Game;
  public var font: String;
  public var fontSize: Int;

  public function new(g: Game)
    {
      game = g;
      font = Const.getVar('--text-font');
      fontSize = Const.getVarInt('--text-font-size');
    }

// run options command
// 0 - error, show standard error message
// 1 - success
// -1 - error, skip standard error message
  public function runCommand(tokens: Array<String>): Int
    {
      if (tokens.length == 0)
        {
          print();
          return -1;
        }

      var key = tokens[0];
      var info = options[key];
      if (info == null)
        {
          p('No such option.');
          return -1;
        }
      if (tokens.length == 1)
        {
          p(key + ' = ' + Reflect.field(this, info.id));
          return -1;
        }

      // set option
      var val:Dynamic = tokens[1];
      if (info.values != null)
        {
          if (!Lambda.has(info.values, val))
            {
              p('Allowed values: [' + info.values.join(', ') + ']');
              return -1;
            }
        }
      if (info.type == 'int')
        val = Std.parseInt(val);
      Reflect.setField(this, info.id, val);
      setPost(info.id);
      
      return -1;
    }

// option set handling
  function setPost(key: String)
    {
      if (key == 'font')
        Const.setVar('--text-font', font);
      else if (key == 'fontSize')
        Const.setVar('--text-font-size', fontSize + 'px');
    }

// print all options values
  function print()
    {
      var s = 'Options:\n';
      for (f in options.keys())
        {
          var o = options[f];
          s += '&nbsp;&nbsp;&nbsp;&nbsp;' + o.id +
            ' = ' + Reflect.field(this, o.id) +
            ' - ' + o.name;
          if (o.values != null)
            s += ' [' + o.values.join(', ') + ']';
          s += '\n';
        }
      p(s);
    }

  inline function p(s: String)
    {
      game.console.print(s);
    }

  var options: Map<String, _Option> = [
    'font' => {
      id: 'font',
      type: 'string',
      name: 'Font family',
	  values: [ 'crimson', 'dos', 'monospace', 'ps55', 'vt323' ],
    },
    'fontsize' => {
      id: 'fontSize',
      type: 'int',
      name: 'Font size',
    },
  ];
}

typedef _Option = {
  var id: String;
  var type: String;
  var name: String;
  @:optional var values: Array<String>;
}
