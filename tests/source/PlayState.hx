package;

import flixel.text.FlxText;
import flixel.extended.ExtendedSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();
		var sprite = new ExtendedSprite(0, 0); 
		sprite.screenCenter();
		add(sprite);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
