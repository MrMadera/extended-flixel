package flixel.macro;

import haxe.io.Path;
import flixel.console.ConsoleUtils;
import sys.FileSystem;
import sys.io.Process;
import sys.io.File;
import Math;

using StringTools;

enum CommandType
{
    BUILD;
    TEST;
}

class Build
{
    public static function main() 
    {
        var args = Sys.args();

        if (args.length == 0) {
            Sys.println("Usage: haxelib run <library-name> <command>");
            return;
        }

        switch (args[0]) 
        {
            case "setup" | "s":
                Sys.println("Setup started!");
                setup();
            case "build" | "b":
                compile(BUILD);
            case "test" | "t":
                compile(TEST);
            case "run" | "r":
                run();
            default:
                Sys.println("Unknown command: " + args[0]);
        }    
    }

    static function setup() 
    {
        var cmdContent = '@haxelib --global run extended-flixel %*\n';

        var haxePath = Sys.getEnv("HAXEPATH");
        if(haxePath == null)
        {
            // aborting...
            log("ERROR: HAXEPATH is not defined. Aborting...");
            Sys.exit(1);
        }
        var filePath = haxePath + '/extended-flixel.cmd';
        var filePath2 = haxePath + '/ef.cmd';

        File.saveContent(filePath, cmdContent);
        File.saveContent(filePath2, cmdContent);

        log("Done.");
    }

    static function compile(type:CommandType)
    {
        log(warningText);
        log();
        log("You're gonna execute a custom build process which is right now in BETA.");
        Sys.print("Which OS are you building? (windows/mac/linux) ");
        var osHelper = Sys.stdin().readLine();
        var osArray = osHelper.split(",");
        if(["w", "windows", "m", "mac", "l", "linux"].contains(osArray[0]))
        {
            if(osArray.length > 1) {
                log("You cannot test a build for more than one OS. Aborting...");
                Sys.exit(1);
            }

            Sys.print("Write here your custom flags (if you don't want to use any, just press enter): ");
            var flagHelpder = Sys.stdin().readLine();
            if(flagHelpder.toLowerCase().trim() != "")
            {
                customFlags = flagHelpder;
            }

            switch(osHelper)
            {
                case 'windows' | 'w':
                    osName = "Windows";
                case 'mac' | 'm':
                    osName = "Mac";
                case 'linux' | 'l':
                    osName = "Linux";
                default:
                    log("Invalid OS. Aborting...");
                    Sys.exit(1);
            }

            log("Building for " + osName + "...");
            Sys.sleep(0.4);
    
            var curDirectory = Sys.args().copy().pop();
            Sys.setCwd(curDirectory);

            createBuildFile();

            if(customFlags.contains("-reinstall")) reinstallLibraries();

            var lowerCaseOsName = osName.toLowerCase();

            Sys.command("lime update " + lowerCaseOsName + " -verbose " + customFlags);
            logProjectXMLData();
            var command = Sys.command("lime build " + lowerCaseOsName + " " + customFlags);
            if(command != 0) return;
            calculateBuildTime();
            if(type == TEST) Sys.command("lime run " + lowerCaseOsName + " " + customFlags);
        }
    }

    static function run()
    {
        Sys.print("Which OS are you running? [you can ONLY write one] (windows/mac/linux) ");
        var osHelper = Sys.stdin().readLine();
        var osArray = osHelper.split(",");
        if(["w", "windows", "m", "mac", "l", "linux"].contains(osArray[0]))
        {
            if(osArray.length > 1) {
                log("You cannot test a build for more than one OS. Aborting...");
                Sys.exit(1);
            }

            Sys.print("Write here your custom flags (if you don't want to use any, just press enter): ");
            var flagHelpder = Sys.stdin().readLine();
            if(flagHelpder.toLowerCase().trim() != "")
            {
                customFlags = flagHelpder;
            }

            switch(osHelper)
            {
                case 'windows' | 'w':
                    osName = "Windows";
                case 'mac' | 'm':
                    osName = "Mac";
                case 'linux' | 'l':
                    osName = "Linux";
                default:
                    log("Invalid OS. Aborting...");
                    Sys.exit(1);
            }

            log("Running for " + osName + "...");
            Sys.sleep(0.4);
    
            var curDirectory = Sys.args().copy().pop();
            Sys.setCwd(curDirectory);

            var lowerCaseOsName = osName.toLowerCase();

            Sys.command("lime update " + lowerCaseOsName + " -verbose " + customFlags);
            Sys.command("lime run " + lowerCaseOsName + " " + customFlags);
        }
        else
        {
            log("Invalid OS. Aborting...");
            Sys.exit(1);
        }
    }

    static function createBuildFile()
    {
        // IMPORTANT DATA (using in this function cuz is used in both functions)
        if(customFlags.contains("-verbose"))
        {
            isVerboseMode = true;
        }

        if(customFlags.contains("-debug"))
        {
            isDebugMode = true;
        }

        var content:String = Date.now().toString();

        log();
        
        // creates a directory in case it's null
        if(!FileSystem.exists("temp/")) 
        {
            if(isVerboseMode) {
                log("TEMPORAL FOLDER NOT DETECTED!", ERROR, true);
                log();
            } 
            FileSystem.createDirectory("temp");
        }

        File.append(buildFileLocation, false);
        File.saveContent(buildFileLocation, content);
        log('The build file has been created!', AFIRMATIVE, true);
    }

    static function calculateBuildTime()
    {
        var dateWhenBuildStarted = Date.fromString(File.getContent(buildFileLocation));
        if(isVerboseMode || isDebugMode) log('The file was created in $dateWhenBuildStarted');

        var currentDate = Date.now();
        if(isVerboseMode || isDebugMode) log('The current time is $currentDate');

        var difference = currentDate.getTime() - dateWhenBuildStarted.getTime();
        if(isVerboseMode || isDebugMode) log('The difference (in milliseconds) is ${currentDate.getTime()} - ${dateWhenBuildStarted.getTime()} = $difference');

        var seconds = difference / 1000;
        if(isVerboseMode || isDebugMode) log('Dividing by 1000 we get $seconds');

        var minutes = roundDecimal(seconds / 60, 1);
        var minuteText:String;
        if(minutes == 1) minuteText = 'minute'; else minuteText = 'minutes';
        log(ConsoleUtils.yellow + 'Build took: ' + seconds + ' seconds ($minutes $minuteText)' + ConsoleUtils.reset);

        Sys.sleep(0.5);
        if (FileSystem.exists(buildFileLocation)) {
            try
            {   /*
                var cwd = Sys.getCwd();
                cwd = Path.normalize(cwd);
                log("CWDDDDDDDD " + cwd);
                //FileSystem.deleteFile(buildFileLocation);
                switch(osName)
                {
                    case 'Windows':
                        Sys.command('del "$cwd/$buildFileLocation"');
                    case 'Mac' | 'Linux':
                        Sys.command('rm "$buildFileLocation"');
                    default:
                        log('IDKKKKKK');
                }
                if(isVerboseMode || isDebugMode) log('BUILD FILE DELETED SUCCESSFULLY!', AFIRMATIVE);
                */
                if(isVerboseMode || isDebugMode) log(ConsoleUtils.yellow + ConsoleUtils.bold + 'WARNING:' + ConsoleUtils.reset + ' Build file cannot be deleted.', NORMAL);
            }
            catch(exc)
            {
                if(isVerboseMode || isDebugMode) log('WARNING: Build file cannot be deleted.', ERROR, true);
            }
        } else {
            if(isVerboseMode || isDebugMode) log('WARNING: Build file not found. Nothing to delete.', ERROR, true);
        }
    }

    static function roundDecimal(value:Float, precision:Int):Float {
        var factor = Math.pow(10, precision);
        return Math.round(value * factor) / factor;
    }

    static function reinstallLibraries()
    {
        Sys.command("hmm reinstall -f");
    }

    static function logProjectXMLData()
    {
        var cwd = Sys.getCwd();
        cwd = Path.normalize(cwd);

        if(isDebugMode || isVerboseMode) log('Seraching project.xml file in the following directory: $cwd', AFIRMATIVE, true);

        var projectXML = File.getContent(cwd + '/project.xml');
        var appStuff = Xml.parse(projectXML).firstElement().elementsNamed("app"); // getting the first one cuz there are like a ton of app references????

        var app = null;
        for (elem in appStuff) {
            if (elem.get("title") != null && elem.get("version") != null) {
                app = elem;
                break;
            }
        }

        // avoiding if it's null haha it has crashed 7 times already :)
        if (app != null) {
            var title = app.get("title");
            var version = app.get("version");

            log();
            log(' - Project title: ' + title, NORMAL, true);
            log(' - Project version: ' + version, NORMAL, true);
            log();
        } else {
            log("Could not find an <app> node with title and version.", ERROR, true);
        }
    }

    public static function log(?log:String = "", lineType:LineType = NORMAL, bold:Bool = false, underline:Bool = false) 
    {
        #if sys
            switch(lineType)
            {
                case ERROR:
                    if(bold)
                    {
                        var prevLog = log;
                        log = ConsoleUtils.bold + prevLog;
                    }
                    if(underline)
                    {
                        var prevLog = log;
                        log = ConsoleUtils.underline + prevLog;
                    }
                    
                    Sys.println(ConsoleUtils.red + log + ConsoleUtils.reset);
                case WARNING:
                    if(bold)
                    {
                        var prevLog = log;
                        log = ConsoleUtils.bold + prevLog;
                    }
                    if(underline)
                    {
                        var prevLog = log;
                        log = ConsoleUtils.underline + prevLog;
                    }

                    Sys.println(ConsoleUtils.yellow + log + ConsoleUtils.reset);
                case AFIRMATIVE:
                    if(bold)
                    {
                        var prevLog = log;
                        log = ConsoleUtils.bold + prevLog;
                    }
                    if(underline)
                    {
                        var prevLog = log;
                        log = ConsoleUtils.underline + prevLog;
                    }

                    Sys.println(ConsoleUtils.green + log + ConsoleUtils.reset);
                default:
                    if(bold)
                    {
                        var prevLog = log;
                        log = ConsoleUtils.bold + prevLog + ConsoleUtils.reset;
                    }
                    if(underline)
                    {
                        var prevLog = log;
                        log = ConsoleUtils.underline + prevLog + ConsoleUtils.reset;
                    }

                    Sys.println(log);
            }
        #else
            trace('\n' + log);
        #end
    }
    
    static var warningText:String = File.getContent('assets/data/warning.txt');
    static var buildFileLocation:String = 'temp/build_time.BUILD';
    static var isVerboseMode:Bool = false;
    static var isDebugMode:Bool = false;
    static var customFlags:String = ""; //global variable
    static var osName:String = "";
}

enum LineType
{
    ERROR;
    WARNING;
    AFIRMATIVE;
    NORMAL;
}
