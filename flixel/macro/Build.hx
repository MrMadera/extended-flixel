package flixel.macro;

import console.ConsoleUtils;
import sys.FileSystem;
import sys.io.Process;
import sys.io.File;
import Math;

using StringTools;

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
                build();
            case "test" | "t":
                test();
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

    static function build()
    {
        log(warningText);
        log("");
        log("You're gonna execute a custom build process which is right now in BETA.");
        log("");
        Sys.print("Which OS are you building? [you can put more than one separeted by comma] (windows/mac/linux) ");
        var osHelper = Sys.stdin().readLine();
        var array = osHelper.split(",");
        if(["w", "windows", "m", "mac", "l", "linux"].contains(array[0]))
        {
            log("");
            Sys.print("Write here your custom flags (if you don't want to use any, just press enter): ");
            var flagHelpder = Sys.stdin().readLine();
            if(flagHelpder.toLowerCase().trim() != "")
            {
                customFlags = flagHelpder;
            }

            // starting compilation
            var arrayOfOs = osHelper.split(",");
            for(os in arrayOfOs)
            {
                var osName:String = "";
                if(os == 'windows' || os == 'w') osName = "Windows";
                else if(os == 'mac' || os == 'm') osName = "Mac";
                else if(os == 'linux' || os == 'l') osName = "Linux";

                log("Building for " + osName + "...");
                Sys.sleep(0.4);
        
                var curDirectory = Sys.args().copy().pop();
                Sys.setCwd(curDirectory);

                createBuildFile();

                if(customFlags.contains("-reinstall")) reinstallLibraries();
                
                if(osHelper == 'windows' || osHelper == 'w')
                {
                    Sys.command("lime update windows -verbose" + customFlags);
                    Sys.command("lime build windows " + customFlags);
                    calculateBuildTime();
                }
                else if(osHelper == 'mac' || osHelper == 'm') 
                {
                    Sys.command("lime update mac " + customFlags);
                    Sys.command("lime build mac " + customFlags);
                    calculateBuildTime();
                }
                else if(osHelper == 'linux' || osHelper == 'l') 
                {
                    Sys.command("lime update linux " + customFlags);
                    Sys.command("lime build linux " + customFlags);
                    calculateBuildTime();
                }
            }
        }
        else
        {
            log("Invalid OS. Aborting...");
            Sys.exit(1);
        }
    }

    static function test()
    {
        log(warningText);
        log("");
        log("You're gonna execute a custom test process which is right now in BETA.");
        log("");
        Sys.print("Which OS are you building? [you can ONLY write one] (windows/mac/linux) ");
        var osHelper = Sys.stdin().readLine();
        if(["w", "windows", "m", "mac", "l", "linux"].contains(osHelper))
        {
            log("");
            Sys.print("Write here your custom flags (if you don't want to use any, just press enter): ");
            var flagHelpder = Sys.stdin().readLine();
            if(flagHelpder.toLowerCase().trim() != "")
            {
                customFlags = flagHelpder;
            }

            // starting compilation
            var osName:String = osHelper;

            if(osName == 'windows' || osName == 'w') osName = "Windows";
            else if(osName == 'mac' || osName == 'm') osName = "Mac";
            else if(osName == 'linux' || osName == 'l') osName = "Linux";

            log("Building for " + osName + "...");
            Sys.sleep(0.4);
    
            var curDirectory = Sys.args().copy().pop();
            Sys.setCwd(curDirectory);

            createBuildFile();

            if(customFlags.contains("-reinstall")) reinstallLibraries();
            
            if(osHelper == 'windows' || osHelper == 'w')
            {
                Sys.command("lime update windows -verbose" + customFlags);
                Sys.command("lime build windows " + customFlags);
                calculateBuildTime();
                Sys.command("lime run windows " + customFlags);
            }
            else if(osHelper == 'mac' || osHelper == 'm') 
            {
                Sys.command("lime update mac " + customFlags);
                Sys.command("lime build mac " + customFlags);
                calculateBuildTime();
                Sys.command("lime run mac " + customFlags);
            }
            else if(osHelper == 'linux' || osHelper == 'l') 
            {
                Sys.command("lime update linux " + customFlags);
                Sys.command("lime build linux " + customFlags);
                calculateBuildTime();
                Sys.command("lime run linux " + customFlags);
            }
        }
        else
        {
            log("Invalid OS. Aborting...");
            Sys.exit(1);
        }
    }

    static function createBuildFile()
    {
        var content:String = Date.now().toString();

        // creates a directory in case it's null
        if(!FileSystem.exists("temp/")) 
        {
            log("Creating TEMPORAL folder!!", AFIRMATIVE);
            FileSystem.createDirectory("temp");
        }

        File.append(buildFileLocation, false);
        File.saveContent(buildFileLocation, content);
        log('BUILD FILE CREATED!', AFIRMATIVE);

        // IMPORTANT DATA (using in this function cuz is used in both functions)
        if(customFlags.contains("-verbose"))
        {
            isVerboseMode = true;
        }

        if(customFlags.contains("-debug"))
        {
            isDebugMode = true;
        }
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
        log(ConsoleUtils.yellow + 'Build took: ' + seconds + ' seconds (${Math.round(seconds / 60)} minutes)' + ConsoleUtils.reset);

        Sys.sleep(0.5);
        if (FileSystem.exists(buildFileLocation)) {
            try
            {
                FileSystem.deleteFile(buildFileLocation);
                if(isVerboseMode || isDebugMode) log('BUILD FILE DELETED SUCCESSFULLY!', AFIRMATIVE);
            }
            catch(exc)
            {
                if(isVerboseMode || isDebugMode) log('WARNING: Build file cannot be deleted.', ERROR, true);
            }
        } else {
            if(isVerboseMode || isDebugMode) log('WARNING: Build file not found. Nothing to delete.', ERROR, true);
        }
    }

    static function reinstallLibraries()
    {
        Sys.command("hmm reinstall -f");
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
                        log = ConsoleUtils.bold + prevLog;
                    }
                    if(underline)
                    {
                        var prevLog = log;
                        log = ConsoleUtils.underline + prevLog;
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
}

enum LineType
{
    ERROR;
    WARNING;
    AFIRMATIVE;
    NORMAL;
}