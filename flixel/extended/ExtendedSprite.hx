package flixel.extended;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxAxes;

class ExtendedSprite extends FlxSprite
{
    // TODO: Add descriptions to everything

    public var graphicPath:String;
    public var isAnimated:Bool;

    public var elapsedTime:Float;

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

    public function addSparrowAnimation(name:String, anim:String, framerate:Int, loop:Bool)
    {
        if(!isAnimated) return;

        animation.addByPrefix(name, anim, framerate, loop);
    }

    public function playAnim(name:String)
    {
        if(!isAnimated) return;

        animation.play(name);
    }

    public function playFromFrame(name:String, frame:Int)
    {
        if(!isAnimated) return;

        animation.play(name, false, false, frame);
    }

    public function shakeObject(intensity:Float, time:Float, axes:FlxAxes)
    {
        FlxTween.shake(this, intensity, time, axes);
    }

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

    public function doTween(values:Dynamic, duration:Float, ?options:TweenOptions)
    {
        FlxTween.tween(this, values, duration, options);
    }
}