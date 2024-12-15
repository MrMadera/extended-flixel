package;

import flixel.net.InternetCheck;
import flixel.text.FlxText;
import flixel.extended.ExtendedSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	var sprite:ExtendedSprite;
	override public function create()
	{
		super.create();

		sprite = new ExtendedSprite(0, 0, 'assets/images/BOYFRIEND.png', true);
		sprite.addSparrowAnimation('idle', 'BF idle dance', 24, true);
		sprite.playAnim('idle');
		sprite.screenCenter();
		sprite.shakeObject(3, 2);
		sprite.doTween({alpha: 0}, 2, {type: PINGPONG});
		add(sprite);

		InternetCheck.execute(function(success:Bool)
		{
			if(!success) return;

			var txt = new FlxText(0, 600, 0, "Internet connection avaible", 16);
			txt.screenCenter(X);
			add(txt);
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if(sprite.isOverlaping(true, true))
		{
			#if debug trace('You\'re overlaping bf!'); #end
		}
	}
}
