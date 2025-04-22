package flixel.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;

/**
 * Custom button that extends `FlxSpriteGroup` with customizable functions
**/
class CustomButton extends FlxSpriteGroup
{
    /**
     * The color of the background of the button when it's selected.
     */
    public var bgSelectedColor:FlxColor = 0xFFFFFFFF;
    /**
     * The color of the text of the button when it's selected.
     */
    public var txtSelectedColor:FlxColor = 0xFF000000;
    /**
     * The color of the background of the button when not selected.
     */
    public var bgColor:FlxColor;
    /**
     * The color of the text of the button when not selected.
     */
    public var txtColor:FlxColor;
    /**
     * The width of the button's background.
     */
    public var bgWidth:Int;
    /**
     * The height of the button's background.
     */
    public var bgHeight:Int;
    /**
     * Function / Callback called when the button is pressed.
     */
    public var onPress:Void -> Void;
    /**
     * The background sprite of the button.
     */
    public var bg:FlxSprite;
    /**
     * The image used in the button.
     */
    public var image:FlxSprite;
    /**
     * The text label of the button.
     */
    public var txt:FlxText;

    // Optional stuff
    /**
     * If true, the button will be able to play sounds in a couple of cases.
     */
    public var usingSounds:Bool = false;
    /**
     * The path to the select sound in `assets`.
     */
    public var selectButtonSoundPath:String = '';
    /**
     * The path to the press sound in `assets`.
     */
    public var pressButtonSoundPath:String = '';
    /**
     * If true, the last camera will be checked when checking for overlapping and presses.
     */
    public var getLastCamera:Bool = false;
    /**
     * If true, the button will be able to use an image instead of text.
     */
    public var usesImage:Bool = false;
    /**
     * The camera that will be checked when checking for overlapping and presses.
     */
    public var cameraToGet:Int = 1;
    /**
     * The custom font used for the button's text.
     */
    public var customTextFont:String = '';

    /**
     * Instantiates a new button.
     * 
     * @param x             The X position of the button.
     * @param y             The Y position of the button.
     * @param width         The width of the button.
     * @param height        The height of the button.
     * @param _bgColor      The **(OPTIONAL)** color of the background of the button.
     * @param text          The text for the label of the button.
     * @param size          The size of the text used for the button's label.
     * @param _txtColor     The color of the text used for the button's label.
     * @param _onPress      Callback / Function called when the button is pressed.
     * @param _usesImage    If `true`, the button will use an image instead of a text label. **(OPTIONAL)**
     * @param imagePath     The path of the image used in the button if `_usesImage` is true.
     * @param _customFont   The custom font for the button's text label.
     */
    public function new(x:Float, y:Float, width:Int, height:Int, _bgColor:FlxColor, text:String, size:Int, _txtColor:FlxColor, _onPress:Void -> Void, _usesImage:Bool = false, imagePath:Null<Dynamic> = null, _customFont:String = '')
    {
        bgColor = _bgColor;
        txtColor = _txtColor;
        bgWidth = width;
        bgHeight = height;
        onPress = _onPress;
        usesImage = _usesImage;
        customTextFont = _customFont;

        super(x, y);

        this.scrollFactor.set();
        scrollFactor.set();

        bg = new FlxSprite().makeGraphic(width, height, _bgColor);
        bg.scrollFactor.set();
        add(bg);

        if(imagePath != null && _usesImage)
        {
            image = new FlxSprite().loadGraphic(imagePath);
            image.scrollFactor.set();
            image.color = txtColor;
            image.y = (bg.height / 2) - (image.height / 2);
            image.x = (bg.width / 2) - (image.width / 2);
            add(image);
        }
        else
        {
            txt = new FlxText(0, 0, bg.width, text, size);
            txt.scrollFactor.set();
            txt.setFormat(customTextFont != '' ? customTextFont : 'VCR OSD Mono', size, txtColor, CENTER);
            txt.y = (bg.height / 2) - (txt.height / 2);
            add(txt);
        }
    }
    
    /**
     * If a sound has been played. Used for debouncing.
     */
    var soundPlayed:Bool = false;

    override function update(elapsed:Float)
    {
        var hudMousePos = FlxG.mouse.getScreenPosition(FlxG.cameras.list[FlxG.cameras.list.length - cameraToGet]);
        //if(FlxG.mouse.overlaps(bg))
        if(getLastCamera)
        {
            if(bg.overlapsPoint(hudMousePos))
            {
                if(!soundPlayed && usingSounds)
                {
                    if(selectButtonSoundPath != '') try { FlxG.sound.play(selectButtonSoundPath); }
                    soundPlayed = true;
                }
                bg.makeGraphic(bgWidth, bgHeight, bgSelectedColor);
                if(usesImage) image.color = txtSelectedColor;
                else txt.color = txtSelectedColor;

                if(FlxG.mouse.justPressed)
                {
                    onPress();
                    if(pressButtonSoundPath != '' && usingSounds) try { FlxG.sound.play(pressButtonSoundPath); }
                }
            }
            else
            {
                bg.makeGraphic(bgWidth, bgHeight, bgColor);
                if(usesImage) image.color = txtColor;
                else txt.color = txtColor;
                soundPlayed = false;
            }
        }
        else
        {
            if(FlxG.mouse.overlaps(bg))
            {
                if(!soundPlayed && usingSounds)
                {
                    if(selectButtonSoundPath != '') try { FlxG.sound.play(selectButtonSoundPath); }
                    soundPlayed = true;
                }
                bg.makeGraphic(bgWidth, bgHeight, bgSelectedColor);
                txt.color = txtSelectedColor;
                if(FlxG.mouse.justPressed)
                {
                    onPress();
                    if(pressButtonSoundPath != '' && usingSounds) try { FlxG.sound.play(pressButtonSoundPath); }
                }
            }
            else
            {
                bg.makeGraphic(bgWidth, bgHeight, bgColor);
                txt.color = txtColor;
                soundPlayed = false;
            }
        }
        super.update(elapsed);
    }
}