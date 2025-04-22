package flixel.particles;

import flixel.group.FlxSpriteGroup;
import flixel.particles.Particle;
import flixel.FlxG;

/**
 * Class used to spawn particles dynamically.
 */
class ParticleSystem extends FlxSpriteGroup
{
	/**
	 * The number of particles that will be generated when `generateParticles()` is called.
	 */
	public var particlesNum:Int = 3;

    /**
     * Instantiates a new `ParticleSystem`.
     * @param x The X position of this instance.
     * @param y The Y position of this instance.
     */
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
    }

    /**
     * Generates particles dynamically. The amount is defined by `particlesNum`.
     * 
     * @param particlePath The path of the particles image in `assets`.
     */
    public function generateParticles(particlePath:Dynamic)
    {
        for (i in 0...particlesNum) 
        {
            var spacingFactor:Float = 1.0 / particlesNum;
            var particleX:Float = FlxG.width * (i * spacingFactor * FlxG.random.float(0.6, 1.4));
            var particleY:Float = FlxG.height * (i * spacingFactor * FlxG.random.float(0.45, 1.55));
            var particle:Particle = new Particle(particleX, particleY, particlePath);
            add(particle);
        }
    }
}