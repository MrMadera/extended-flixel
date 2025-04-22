package flixel.console;

/**
 * Class that contains some useful codes for text styles & colors.
**/
class ConsoleUtils
{
    // Colors
    // Yes, I'm about to name every single color... -Dyscarn
    /**
     * The color Red.
     */
    public static var red:String = "\033[31m";
    /**
     * The color Green.
     */
    public static var green:String = "\033[32m";
    /**
     * The color Yellow.
     */
    public static var yellow:String = "\033[33m";
    /**
     * The color Blue.
     */
    public static var blue:String = "\033[34m";
    /**
     * The color Magenta.
     */
    public static var magenta:String = "\033[35m";
    /**
     * The color Cyan.
     */
    public static var cyan:String = "\033[36m";
    /**
     * The color White.
     */
    public static var white:String = "\033[37m";

    // Text Styles
    /**
     * Bolded text.
     */
    public static var bold:String = "\033[1m";
    /**
     * Underlined text.
     */
    public static var underline:String = "\033[4m";

    // Reset
    /**
     * Default text.
     */
    public static var reset:String = "\033[0m";
}
