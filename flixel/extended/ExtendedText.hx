package flixel.extended;

import flixel.text.FlxText;

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
}