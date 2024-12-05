package;

import flixel.text.FlxText;
import flixel.extended.ExtendedSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();

		var sprite = new ExtendedSprite(0, 0, 'assets/images/BOYFRIEND.png', true);
		sprite.addSparrowAnimation('idle', 'BF idle dance', 24, true);
		sprite.playAnim('idle');
		sprite.screenCenter();
		sprite.shakeObject(3, 2);
		add(sprite);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
