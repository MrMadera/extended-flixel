package flixel.extended;

import flixel.FlxSprite;

class ExtendedSprite extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0, ?simpleGraphic:Null<FlxGraphicAssets>)
    {
        super(x, y, simpleGraphic);
    }
}