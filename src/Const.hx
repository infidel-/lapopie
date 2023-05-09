class Const
{
// reverse compass directions
  public static var compassDirectionReverse: Map<_CompassDirection, _CompassDirection> = [
    NORTH => SOUTH,
    NE => SW,
    NW => SE,
    SOUTH => NORTH,
    SE => NW,
    SW => NE,
    EAST => WEST,
    WEST => EAST,
    UP => DOWN,
    DOWN => UP,
  ];
  public static var compassPropsReverse: Map<String, String> = [
    'n' => 's',
    's' => 'n',
    'e' => 'w',
    'w' => 'e',
    'ne' => 'sw',
    'nw' => 'se',
    'se' => 'nw',
    'sw' => 'ne',
    'd' => 'u',
    'u' => 'd',
  ];
  public static var compassDirectionProps: Map<String, _CompassDirection> = [
    'n' => NORTH,
    's' => SOUTH,
    'e' => EAST,
    'w' => WEST,
    'ne' => NE,
    'nw' => NW,
    'se' => SE,
    'sw' => SW,
    'd' => DOWN,
    'u' => UP,
  ];
}
