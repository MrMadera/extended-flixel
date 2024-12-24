package flixel.macro;

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
            // custom flags
            var customFlags:String = "";

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
                
                if(os == 'windows' || os == 'w') Sys.command("lime build windows " + customFlags);
                else if(os == 'mac' || os == 'm') Sys.command("lime build mac " + customFlags);
                else if(os == 'linux' || os == 'l') Sys.command("lime build linux " + customFlags);

                calculateBuildTime();
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
            // custom flags
            var customFlags:String = "";

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
            
            if(osHelper == 'windows' || osHelper == 'w') Sys.command("lime test windows " + customFlags);
            else if(osHelper == 'mac' || osHelper == 'm') Sys.command("lime test mac " + customFlags);
            else if(osHelper == 'linux' || osHelper == 'l') Sys.command("lime test linux " + customFlags);
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
        File.append("build_time.BUILD", false);
        File.saveContent("build_time.BUILD", content);
        log('BUILD FILE CREATED!');
    }

    static function calculateBuildTime()
    {
        var dateWhenBuildStarted = Date.fromString(File.getContent("build_time.BUILD"));
        log('The file was created in $dateWhenBuildStarted');

        var currentDate = Date.now();
        log('The current time is $currentDate');

        var difference = currentDate.getTime() - dateWhenBuildStarted.getTime();
        log('The difference (in milliseconds) is ${currentDate.getTime()} - ${dateWhenBuildStarted.getTime()} = $difference');

        var seconds = difference / 1000;
        log('Dividing by 1000 we get $seconds');
        log('Build took: ' + seconds + ' seconds (${Math.round(seconds / 60)} minutes)');

        //FileSystem.deleteFile("build_time.BUILD");
        //log('BUILD FILE DELETED!');
    }

    public static function log(?log:String = "") {
        #if sys
        Sys.println(log);
        #else
        trace('\n' + log);
        #end
    }
    
    static var warningText:String = File.getContent('assets/data/warning.txt');
}