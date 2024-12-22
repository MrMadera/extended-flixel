package flixel.extended;

import flixel.text.FlxText;
import flixel.util.FlxColor;

class ExtendedText extends FlxText
{
    public function new(x:Float, y:Float, width:Int, text:String, size:Int)
    {
        super(x, y, width, text, size);
    }

    public function setBold(isbold:Bool)
    {
        bold = isbold;
    }

    public function setItalic(isitalic:Bool)
    {
        italic = isitalic;
    }

    public function addMarkup(text:String, color:FlxColor, char:String)
    {
        applyMarkup(text, [new FlxTextFormatMarkerPair(new FlxTextFormat(color), char)]);
    }
}