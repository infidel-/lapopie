// various foodstuffs
package items;

class Apple extends Food
{
  public function new(parent: Obj)
    {
      super(parent);
      id = 'apple';
      name = 'apple';
      names = [ 'apple' ];
      article = 'an';
      desc = 'A juicy red apple, ready to offer modest nourishment.';
    }
}
