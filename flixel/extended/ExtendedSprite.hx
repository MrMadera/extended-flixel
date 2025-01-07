package flixel.extended;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxAxes;

class ExtendedSprite extends FlxSprite
{
    /**
     * The graphic path is where the graphics is located in the `assets` folder
    **/
    public var graphicPath:String;

    /**
     * If `true`, the class will automaticlly set animation settings
    **/
    public var isAnimated:Bool;

    /**
     * The elapsed time since the class is instanced
    **/
    public var elapsedTime:Float;

    /**
     *@param x x position
     *@param y y position
     *@param simpleGraphic the graphic of the sprite. it can be a `Dynamic` or a `String`
     *@param _isAnimated if the sprite is animated or not
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
     * adds an sparrow animation to the sprite. if the sprite is not animated, this function won't cause effect
    **/
    public function addSparrowAnimation(name:String, anim:String, framerate:Int, loop:Bool)
    {
        if(!isAnimated) return;

        animation.addByPrefix(name, anim, framerate, loop);
    }

    /**
     * plays an animation. if the sprite is not animated, this function won't cause effect
    **/
    public function playAnim(name:String)
    {
        if(!isAnimated) return;

        animation.play(name);
    }

    /**
     * plays an animation from an specific frame. if the sprite is not animated, this function won't cause effect
    **/
    public function playFromFrame(name:String, frame:Int)
    {
        if(!isAnimated) return;

        animation.play(name, false, false, frame);
    }

    /**
     * shakes an object
    **/
    public function shakeObject(intensity:Float, time:Float, axes:FlxAxes)
    {
        FlxTween.shake(this, intensity, time, axes);
    }

    /**
     * if the cursor is overlaping the sprite, it will return `true`
     *@param pixelPerfect if `true`, the cursor will overlap the sprite if it's touching its pixels and not its hitbox
     *@param getLastCamera if `true`, the overlap will count from the last camera (useful if you're using several cameras)
    **/
    public function isOverlaping(pixelPerfect:Bool, getLastCamera:Bool)
    {
        if(pixelPerfect)
        {
            if(this.pixelsOverlapPoint(FlxG.mouse.getScreenPosition(FlxG.cameras.list[FlxG.cameras.list.length - 1])))
            {
                return true;
            }
        }
        else
        {
            if(getLastCamera)
            {
                if(this.overlapsPoint(FlxG.mouse.getScreenPosition(FlxG.cameras.list[FlxG.cameras.list.length - 1])))
                {
                    return true;
                }
            }
            else
            {
                if(FlxG.mouse.overlaps(this))
                {
                    return true;
                }
            }
        }

        return false;
    }

    /**
     * does a tween duh
    **/
    public function doTween(values:Dynamic, duration:Float, ?options:TweenOptions)
    {
        FlxTween.tween(this, values, duration, options);
    }
}