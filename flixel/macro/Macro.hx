package flixel.macro;

import sys.io.Process;
import sys.io.File;

import flixel.net.InternetCheck;

using StringTools;

class Macro {

    macro
    public static function initiateMacro()
    {
        #if (!SKIP_MACRO)
            log('Building at ${Date.now()}');
            #if (debug || extended_macro)
                log('--------------- [DEBUG MACRO ENABLED] ---------------');
                log(extendedFlixelText);

                log('');
                log('Checking for internet connection...');
                checkingInternetConnection();
                getLibraries();
            #end
        #end

        return macro {};
    }

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

    static function getLibraries()
    {
        final command = "haxelib list";
        var library_list = new Process(command);
        if(library_list.exitCode() != 0) {
            log("Error: Command could not be executed.");
            return;
        }
        var output = library_list.stdout.readAll().toString().split('\n');

        var amountOfLibraries = output.length;

        log();
        log('Found ${amountOfLibraries} libraries:');

        // get libraries names
        for(i in 0...output.length) {
            var libraries = output[i].split(':');
            var libraryName = libraries[0].trim();

            if(libraryName == "") continue;

            log(' * $libraryName');
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