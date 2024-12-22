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
            log('Macro from extended-flixel started!');
            log('Building at ${Date.now()}');
            #if (debug || extended_macro)
                log('[DEBUG] Enabled.');
                log('');
                log(extendedFlixelText);

                log('Checking for internet connection...');
                checkingInternetConnection();
            #end
        #end

        return macro {};
    }

    static function checkingInternetConnection()
    {
        InternetCheck.execute(function(success:Bool) 
        {
            if(success) {
                log('Internet connection is available.');
            } else {
                log('Internet connection is not available.');
            }
        });
    }
    
    public static function log(?log:String = "") {
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