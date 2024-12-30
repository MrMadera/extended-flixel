package flixel.particles;

import flixel.group.FlxSpriteGroup;
import flixel.particles.Particle;

class ParticleSystem extends FlxSpriteGroup
{
	public var particlesNum:Int = 3;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
    }

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