package flixel.extended;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ExtendedText extends FlxSpriteGroup
{
    /**
     * the underline sprite used when `setUnderline` is used
    **/
    public var underlineSprite:FlxSprite;

    /**
     * the text itself. if you want to do something to the text first refer to this variable
    **/
    public var txt:FlxText;

    /**
     * local x position
    **/
    var localX:Float;
    
    /**
     * local y position
    **/
    var localY:Float;

    public function new(x:Float, y:Float, width:Int, text:String, size:Int)
    {
        super();

        localX = x;
        localY = y;

        txt = new FlxText(x, y, width, text, size);
        add(txt);
    }

    /**
     * sets the text bold if the font allows it
    **/
    public function setBold(isbold:Bool)
    {
        txt.bold = isbold;
    }

    /**
     * sets the text italic if the font allows it
    **/
    public function setItalic(isitalic:Bool)
    {
        txt.italic = isitalic;
    }

    /**
     * adds a markup to the text (this allows to add colors to different parts of the text)
     @param text the text lol
     @param color the color of the text
     @param char the char that will state the color pattern
    **/
    public function addMarkup(text:String, color:FlxColor, char:String)
    {
        txt.applyMarkup(text, [new FlxTextFormatMarkerPair(new FlxTextFormat(color), char)]);
    }

    /**
     * adds an underline
    **/
    public function setUnderline(size:Int, color:FlxColor = FlxColor.WHITE)
    {
        underlineSprite = new FlxSprite(localX, localY).makeGraphic(Std.int(width), size, color);
        underlineSprite.y += txt.height + 2;
        add(underlineSprite);
    }
    
    /**
     * sets the alignment
    **/
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
    
    /**
     * what do you think this will do you dumdum???
    **/
    public function setTextColor(thiscolor:FlxColor)
    {
        txt.color = thiscolor;
    }
}