package flixel.macro;

import sys.io.Process;
import sys.io.File;
import farfadox.Version;

using StringTools;

class Macro {
    
    macro
    public static function initiateMacro()
    {
        #if (!SKIP_MACRO)
            log('Macro from extended-flixel started!');
        #end

        return macro {};
    }
    
    public static function log(?log:String = "") {
        #if sys
        Sys.println(log);
        #else
        trace('\n' + log);
        #end
    }
}