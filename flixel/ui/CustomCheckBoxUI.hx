package flixel.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;

/**
 * Custom checkbox that extends `FlxSpriteGroup` with customizable functions.
**/
class CustomCheckBoxUI extends FlxSpriteGroup
{
    /**
     * The sprite used for the background of this checkbox.
     */
    public var checkBox:FlxSprite;
    /**
     * The sprite used for the check of this checkbox.
     */
    public var checkSign:FlxSprite;
    /**
     * The text label of this checkbox.
     */
    public var text:FlxText;

    /**
     * If the checkbox is checked, this value will be `true`.
     */
    public var checked:Bool;
    /**
     * Callback / Function called every time this checkbox is toggled.
     */
    public var callback:Void -> Null<Void>;
    
    /**
     * If `true`, it'll get the last camera when checking for input.
     */
    public var getLastCamera:Bool = false;
    /**
     * Custom text font for this checkbox's text label.
     */
    public var customTextFont:String = '';

    /**
     * Creates a new checkbox instance.
     * 
     * @param x             The X position of this checkbox.
     * @param y             The Y position of this checkbox.
     * @param width         The width of this checkbox.
     * @param height        The height of this checkbox.
     * @param label         The text used to label this checkbox.
     * @param size          The size of the label of this checkbox.
     * @param _customFont   The font used in this checkbox. **(OPTIONAL)**
     */
    public function new(x:Float, y:Float, width:Int = 20, height:Int = 20, label:String, size:Int, _customFont:String = '')
    {
        super(x, y);

        customTextFont = _customFont;

        checkBox = new FlxSprite().makeGraphic(width, height, 0xFFFFFFFF);
        add(checkBox);

        checkSign = new FlxSprite().loadGraphic('assets/images/ui/check_mark.png');
        checkSign.setGraphicSize(width, height);
        add(checkSign);

        text = new FlxText(25, 2, 0, label, size);
		text.setFormat(customTextFont != '' ? customTextFont : 'VCR OSD Mono', size, FlxColor.WHITE, LEFT);
        add(text);

        //centerOnSprite(text, checkBox, false, true);
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

        var hudMousePos = FlxG.mouse.getScreenPosition(FlxG.cameras.list[FlxG.cameras.list.length - 1]);
        if(FlxG.mouse.justPressed && (
            (getLastCamera && this.overlapsPoint(hudMousePos))
                ||
            (!getLastCamera && FlxG.mouse.overlaps(this))))
            clickCheck();
    }

    /**
     * Checks the checkbox by clicking.
     */
    public function clickCheck()
    {
        checked = !checked;
        trace('CHECKED: ' + checked);

        updateCheck();
    }

    /**
     * Updates the checkbox's visuals and callbacks.
     */
    public function updateCheck()
    {
        checkSign.visible = checked;
        if(callback != null) callback();
    }
}