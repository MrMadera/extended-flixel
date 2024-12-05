package flixel.extended;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.graphics.frames.FlxAtlasFrames;

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

    public function shakeObject(intensity:Float, time:Float)
    {
        var ogX:Float = x;
        var ogY:Float = y;

        var endTime = elapsedTime + time;

        sys.thread.Thread.create(() -> {
            while(elapsedTime < endTime)
            {
                #if debug trace('shake time: $elapsedTime/$endTime'); #end
                setPosition(ogX + FlxG.random.float(-intensity, intensity), ogY + FlxG.random.float(-intensity, intensity));
            }
        });
    }
}