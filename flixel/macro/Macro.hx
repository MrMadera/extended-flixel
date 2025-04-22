package flixel.macro;

import sys.io.Process;
import sys.io.File;

import flixel.net.InternetCheck;

using StringTools;

class Macro {

    /**
     * Initializes the macro for usage.
     */
    macro
    public static function initiateMacro()
    {
        #if (!SKIP_MACRO)
            // log('Building at ${Date.now()}');
            // log('--------------- [MACRO ENABLED] ---------------');

            // #if (debug || extended_macro) 
            //     log(extendedFlixelText); 
            // #end

            // log('');
            // log('Checking for internet connection...');

            logChunk([
                'Building at ${Date.now()}',

                '--------------- [MACRO ENABLED] ---------------',

                #if (debug || extended_macro)
                extendedFlixelText,
                #end

                '',

                'Checking for internet connection...'
            ]);

            checkingInternetConnection();
            getLibraries();
        #end

        return macro {};
    }

    /**
     * Checks if there's an internet connection available in the current device.
     */
    static function checkingInternetConnection()
    {
        InternetCheck.executeCurl(function(success:Bool) 
        {
            if(success) {
                log('Internet connection is available.');
            } else {
                log('Internet connection is not available.');
            }
        });
    }

    /**
     * Gets the list of libraries that are currently installed in the caller's haxelib.
     */
    static function getLibraries()
    {
        final command:String = "haxelib list";
        var library_list:Process = new Process(command);
        if(library_list.exitCode() != 0) {
            log("Error: Command could not be executed.");
            return;
        }
        var output:Array<String> = library_list.stdout.readAll().toString().split('\n');

        final amountOfLibraries:Int = output.length;

        // log();
        // log('Found ${amountOfLibraries} libraries:');
        logChunk([
            "",
            
            'Found ${amountOfLibraries} libraries:'
        ]);

        // get libraries names
        for(i in 0...output.length) {
            var libraries = output[i].split(':');
            var libraryName = libraries[0].trim();

            if(libraryName == "") continue;

            log(' * $libraryName');
        }

        log();
    }

    /**
     * Logs multiple values at once in order.
     * 
     * @param logs The values that'll be logged. Must be in order.
     */
    public static function logChunk(?logs:Array<Dynamic>) {
        if(logs == null) logs = [""];

        for(log in logs)
        {
            #if sys
            Sys.println(log);
            #else
            trace('\n' + log)
            #end
        }
    }
    
    public static function log(?log:Dynamic = "") {
        #if sys
        Sys.println(log);
        #else
        trace('\n' + log);
        #end
    }

    static var extendedFlixelText:String = "
         _             _       _     ___ _ _         _ 
 ___ _ _| |_ ___ ___ _| |___ _| |___|  _| |_|_ _ ___| |
| -_|_'_|  _| -_|   | . | -_| . |___|  _| | |_'_| -_| |
|___|_,_|_| |___|_|_|___|___|___|   |_| |_|_|_,_|___|_|";

        
}