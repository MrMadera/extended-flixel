package flixel.macro;

import sys.io.Process;
import sys.io.File;

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
            case "setup":
                Sys.println("Setup started!");
                setup();
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

        File.saveContent(filePath, cmdContent);

        log("Done.");
    }

    public static function log(?log:String = "") {
        #if sys
        Sys.println(log);
        #else
        trace('\n' + log);
        #end
    }
}