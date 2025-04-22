package flixel.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.ui.CustomButton;

/**
 * Custom numeric stepper that extends `FlxSpriteGroup` with customizable functions.
**/
class CustomNumericStepperUI extends FlxSpriteGroup
{
    /**
     * The background sprite of this numeric stepper.
     */
    public var bg:FlxSprite;
    /**
     * The text used to display this numeric stepper's value.
     */
    public var text:FlxText;
    /**
     * The plus button of this numeric stepper.
     */
    public var button_plus:CustomButton;
    /**
     * The minus button of this numeric stepper.
     */
    public var button_minus:CustomButton;

    /**
     * The maximum value for this numeric stepper.
     */
    public var maxValue:Float = 400;
    /**
     * The minimum value for this numeric stepper.
     */
    public var minValue:Float = 1;
    /**
     * The current value of this numeric stepper.
     */
    public var value:Float = 0;
    /**
     * Callback / Function called every time the value of this numeric stepper changes.
     */
    public var callback:Void -> Null<Void>;

    public var stepSize:Float;
    public var customTextFont:String = '';

    /**
     * Instantiates a new numeric stepper.
     * 
     * @param x             The X position of the numeric stepper.
     * @param y             The Y position of the numeric stepper.
     * @param _stepSize     The **(OPTIONAL)** size of the steps.
     * @param initialValue  The initial value of the numeric stepper.
     * @param _customFont   The **(OPTIONAL)** font for the text used in the numeric stepper.
     */
    public function new(x:Float, y:Float, _stepSize:Float, initialValue:Float, _customFont:String = '')
    {
        super(x, y);

        // this.scrollFactor.set();
        scrollFactor.set();

        value = initialValue;
        customTextFont = _customFont;

        stepSize = _stepSize;

        bg = new FlxSprite().makeGraphic(60, 20, 0xFFFFFFFF);
        bg.scrollFactor.set();
        add(bg);

        text = new FlxText(0, 2, 0, "" + value, 16);
        text.setFormat(customTextFont != '' ? customTextFont : 'VCR OSD Mono', 16, FlxColor.BLACK, CENTER);
        text.scrollFactor.set();
        add(text);

        button_plus = new CustomButton(70, 0, 20, 20, 0xFF000000, '+', 16, 0xFFFFFFFF, onPressButtonPlus);
        button_plus.scrollFactor.set();
        add(button_plus);
        
        button_minus = new CustomButton(100, 0, 20, 20, 0xFF000000, '-', 16, 0xFFFFFFFF, onPressButtonMinus);
        button_minus.scrollFactor.set();
        add(button_minus);
    }

    /**
     * Called when the plus button of this instance is pressed.
     */
    function onPressButtonPlus():Void
    {
        if(value < maxValue)
            work(true);
    }

    /**
     * Called when the minus button of this instance is pressed.
     */
    function onPressButtonMinus():Void
    {
        if(value > minValue)
            work(false);
    }

    /**
     * Function that makes this numeric stepper work.
     */
    function work(positive:Bool):Void
    {
        if(!positive) value -= stepSize;
        else value += stepSize;
        value = FlxMath.roundDecimal(value, 4);
        if(callback != null) callback();
        updateText();
    }

    /**
     * Updates the text of this instance to display its value.
     */
    public function updateText()
    {
        text.text = Std.string(value);
    }
}