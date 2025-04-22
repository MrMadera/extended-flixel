package flixel.particles;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Particle extends FlxSprite
{
	/**
	 * Tween used to make this particle disappear.
	 */
	public var particleTween:FlxTween;
	/**
	 * The amount of time this particle has left until it disappears.
	 */
	var lifeTime:Float = 0;
	/**
	 * The constant decay of the alpha of this particle during its lifetime.
	 */
	var decay:Float = 0;
	/**
	 * 
	 */
	var originalScale:Float = 1;

	/**
	 * The current alpha of this particle. Shouldn't be changed.
	 */
	public var _alpha:Float = 1;

	/**
	 * Instantiates a new particle.
	 * 
	 * @param x 			The X position of the particle.
	 * @param y 			The Y position of the particle.
	 * @param particlePath 	The path of the particle's image in `assets`.
	 */
	public function new(x:Float, y:Float, particlePath:Dynamic) // dynamic becasue you can load strings or FlxGraphics
	{
		super(x, y);

		loadGraphic(particlePath);

		lifeTime = FlxG.random.float(0.6, 0.9);
		decay = FlxG.random.float(0.8, 1);
		originalScale = FlxG.random.float(0.25, 0.5);
		scale.set(originalScale, originalScale);

		velocity.set(FlxG.random.float(-40, 40), FlxG.random.float(-175, -250));
		//acceleration.set(FlxG.random.float(-10, 10), 25);

		particleTween = FlxTween.tween(this, {x: x + FlxG.random.int(70, 100)}, 2, {ease: FlxEase.cubeInOut, type: PINGPONG});
	}

	/**
	 * Pauses this particle's tween.
	 */
	public function pause()
	{
		particleTween.active = false;
	}

	/**
	 * Resumes this particle's tween.
	 */
	public function resume()
	{
		particleTween.active = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		lifeTime -= elapsed;
        if(lifeTime < 0)
        {
            lifeTime = 0;
            alpha -= decay * elapsed;
            if(alpha > 0)
            {
                scale.set(originalScale * alpha, originalScale * alpha);
            }
        }

		y--;
		alpha = _alpha;
	}
}