package flixel.console;

/**
 * Class that contains some useful codes for text styles & colors
**/
class ConsoleUtils
{
    // Colors
    public static var red:String = "\033[31m";
    public static var green:String = "\033[32m";
    public static var yellow:String = "\033[33m";
    public static var blue:String = "\033[34m";
    public static var magenta:String = "\033[35m";
    public static var cyan:String = "\033[36m";
    public static var white:String = "\033[37m";

    // Text Styles
    public static var bold:String = "\033[1m";
    public static var underline:String = "\033[4m";

    // Reset
    public static var reset:String = "\033[0m";
}
