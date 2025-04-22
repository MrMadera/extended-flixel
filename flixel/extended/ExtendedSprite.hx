package flixel.extended;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxAxes;
import flixel.FlxG;

class ExtendedSprite extends FlxSprite
{
    /**
     * The path where the graphic of this sprite is located in `assets`.
    **/
    public var graphicPath:String;

    /**
     * If `true`, the class will automaticlly set animation settings itself.
    **/
    public var isAnimated:Bool;

    /**
     * The elapsed time since the class was instanced.
    **/
    public var elapsedTime:Float;

    /**
     * Instantiates a new ExtendedSprite for usage.
     * 
     *@param x The X position of the sprite in the world.
     *@param y The Y position of the sprite in the world.
     *@param simpleGraphic The graphic of the sprite. It can be either `Dynamic` or `String`.
     *@param _isAnimated If the sprite is animated.
    **/
    public function new(x:Float = 0, y:Float = 0, ?simpleGraphic:Null<FlxGraphicAsset>, _isAnimated:Bool = false)
    {
        isAnimated = _isAnimated;

        if(simpleGraphic == null)
        {
            simpleGraphic = 'assets/images/no_image.png';
        }
        graphicPath = simpleGraphic;

        #if debug
            trace('Path: $graphicPath');
        #end

        super(x, y, simpleGraphic);

        if(isAnimated)
        {
            frames = FlxAtlasFrames.fromSparrow(simpleGraphic, StringTools.replace(graphicPath, '.png', '.xml'));
        }
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);
        
        elapsedTime += elapsed;
    }

    /**
     * Adds a sparrow animation to the sprite. If the sprite is not animated, this function won't do anything.
     * 
     * @param name      The name / tag of the animation in the animation list.
     * @param anim      The animation name in the animations file of the sprite.
     * @param framerate The framerate the animation should have. Usually `24` or `12`.
     * @param loop      If the animation will play on loop when active.
    **/
    public function addSparrowAnimation(name:String, anim:String, framerate:Int, loop:Bool)
    {
        if(!isAnimated) return;

        animation.addByPrefix(name, anim, framerate, loop);
    }

    /**
     * Plays an animation if it exists. If the sprite is not animated, this function won't do anything.
     * 
     * @param name The name of the animation to play.
    **/
    public function playAnim(name:String)
    {
        if(!isAnimated || !animation.exists(name)) return;

        animation.play(name);
    }

    /**
     * Plays an animation from an specific frame if it exists. If the sprite is not animated, this function won't do anything.
     * 
     * @param name  The name of the animation to play.
     * @param frame The frame number from where it'll start.
    **/
    public function playFromFrame(name:String, frame:Int)
    {
        if(!isAnimated || !animation.exists(name)) return;

        animation.play(name, false, false, frame);
    }

    /**
     * Shakes this sprite.
     * 
     * @param intensity The intensity of the shake.
     * @param time      The amount of time this shake will play for.
     * @param axes      The axes in which the sprite will shake. Usually `XY`.
    **/
    public function shakeObject(intensity:Float, time:Float, ?axes:FlxAxes = XY)
    {
        FlxTween.shake(this, intensity, time, axes);
    }

    /**
     * Checks if the mouse cursor is currently overlapping this sprite.
     * 
     * @param pixelPerfect  If `true`, the check will be made based on the sprite's pixels and not on its hitbox.
     * @param getLastCamera If `true`, the overlap will count from the last camera. (useful if you're using several cameras)
    **/
    public function isOverlaping(pixelPerfect:Bool, getLastCamera:Bool)
    {
        if(pixelPerfect)
            return this.pixelsOverlapPoint(FlxG.mouse.getScreenPosition(FlxG.cameras.list[FlxG.cameras.list.length - 1]));
        else if(getLastCamera)
            return this.overlapsPoint(FlxG.mouse.getScreenPosition(FlxG.cameras.list[FlxG.cameras.list.length - 1]));
        else
            return FlxG.mouse.overlaps(this);
    }

    /**
     * Shortcut to `FlxTween.tween()` for this sprite.
     * 
     * @param values    The values that'll change in the tween.
     * @param duration  The time it will take for the tween to complete.
     * @param options   The options of the tween. (See [TweenOptions](https://api.haxeflixel.com/flixel/tweens/TweenOptions.html))
    **/
    public function doTween(values:Dynamic, duration:Float, ?options:TweenOptions)
    {
        FlxTween.tween(this, values, duration, options);
    }
}