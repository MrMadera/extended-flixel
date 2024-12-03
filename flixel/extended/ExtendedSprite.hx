package flixel.extended;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class ExtendedSprite extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0, ?simpleGraphic:Null<FlxGraphicAsset>)
    {
        if(simpleGraphic == null)
        {
            simpleGraphic = 'assets/images/no_image.png';
        }
        
        super(x, y, simpleGraphic);
    }
}