package flixel.extended;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ExtendedText extends FlxSpriteGroup
{
    public var underlineSprite:FlxSprite;
    public var txt:FlxText;

    var localX:Float;
    var localY:Float;

    public function new(x:Float, y:Float, width:Int, text:String, size:Int)
    {
        super();

        localX = x;
        localY = y;

        txt = new FlxText(x, y, width, text, size);
        add(txt);
    }

    public function setBold(isbold:Bool)
    {
        txt.bold = isbold;
    }

    public function setItalic(isitalic:Bool)
    {
        txt.italic = isitalic;
    }

    public function addMarkup(text:String, color:FlxColor, char:String)
    {
        txt.applyMarkup(text, [new FlxTextFormatMarkerPair(new FlxTextFormat(color), char)]);
    }

    public function setUnderline(size:Int, color:FlxColor = FlxColor.WHITE)
    {
        underlineSprite = new FlxSprite(localX, localY).makeGraphic(Std.int(width), size, color);
        underlineSprite.y += txt.height + 2;
        add(underlineSprite);
    }
    
    public function setAlignment(alignmentString:String)
    {
        switch (alignmentString.toLowerCase())
        {
            case "left":
                txt.alignment = LEFT;
            case "center":
                txt.alignment = CENTER;
            case "right":
                txt.alignment = RIGHT;
            default:
                txt.alignment = LEFT;
        }
    }
    
    public function setTextColor(thiscolor:FlxColor)
    {
        txt.color = thiscolor;
    }
}