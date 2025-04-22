package flixel.extended;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
 * Alternative class to [FlxText](https://api.haxeflixel.com/flixel/text/FlxText.html) extending from [FlxSpriteGroup](https://api.haxeflixel.com/flixel/group/FlxSpriteGroup.html) to add more QoL functions and shortcuts.
**/
class ExtendedText extends FlxSpriteGroup
{
    /**
     * The underline sprite used when `setUnderline` is used.
    **/
    public var underlineSprite:FlxSprite;

    /**
     * The text of this instance. If you want to do something to this instance's text, refer to this variable.
    **/
    public var txt:FlxText;

    /**
     * Local X position of this instance.
    **/
    var localX:Float;
    
    /**
     * Local Y position of this instance.
    **/
    var localY:Float;

    /**
     * Instantiates a new instance of this class.
     * 
     * @param x     The X position of this text.
     * @param y     The Y position of this text.
     * @param width The width of this text's bounding box.
     * @param text  The text that'll be initially shown on this instance.
     * @param size  The initial size of this text.
     */
    public function new(x:Float, y:Float, width:Int, text:String, size:Int)
    {
        super();

        localX = x;
        localY = y;

        txt = new FlxText(x, y, width, text, size);
        add(txt);
    }

    /**
     * Makes the text bold if allowed by the font.
    **/
    public function setBold(isbold:Bool)
    {
        txt.bold = isbold;
    }

    /**
     * Makes the text italic (cursive) if allowed by the font.
    **/
    public function setItalic(isitalic:Bool)
    {
        txt.italic = isitalic;
    }

    /**
     * Adds a markup to the text. This allows to add colors to different parts of the text. Refer to RichText in other engines.
     * @param text  The text to apply the markup to.
     * @param color The color of the text.
     * @param char  The character that will state the color pattern.
    **/
    public function addMarkup(text:String, color:FlxColor, char:String)
    {
        txt.applyMarkup(text, [new FlxTextFormatMarkerPair(new FlxTextFormat(color), char)]);
    }

    /**
     * Adds an underline to this text as a sprite.
    **/
    public function setUnderline(size:Int, color:FlxColor = FlxColor.WHITE)
    {
        underlineSprite = new FlxSprite(localX, localY).makeGraphic(Std.int(width), size, color);
        underlineSprite.y += txt.height + 2;
        add(underlineSprite);
    }
    
    /**
     * Sets the current alignment of the text.
     * 
     * @param alignmentString The alignment that the text will have.
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
     * Sets the color of the text to a set color.
     * 
     * @param thiscolor The color that the entire text will be set to.
    **/
    public function setTextColor(thiscolor:FlxColor)
    {
        txt.color = thiscolor;
    }
}