package flixel.net;

#if sys
import sys.io.Process;
import sys.net.Host;
#end

import haxe.Http;

using StringTools;

/**
 * Class containing a couple of useful functions to use internet connections.
**/
class InternetCheck
{
    /**
     * Used to test url executing with Google to check for an internet connection.
     * 
     * @param callback Function called when the url reacts.
     */
    public static function execute(callback:Bool->Void)
    {
        var url = "https://www.google.com";
        var http = new Http(url);
        http.onData = function(data) 
        {
            //trace('fetching data!');
            callback(true);
        };
        http.onError = function(error) 
        {
            //trace("Error: " + error);
            callback(false);
        };
        http.request(false);
        #if sys
        Sys.sleep(2);
        #end
    }

    /**
     * Function used to execute curl and check if an internet connection is available.
     * 
     * @param callback Function called back when finishing checks.
     */
    public static function executeCurl(callback:Bool->Void) 
    {
        #if sys
        try {
            var process = new Process("curl", ["-s", "-o", "/dev/null", "-w", "%{http_code}", "https://www.google.com"]);
            var outputBytes = process.stdout.readAll(); // Read the output as Bytes
            var output = outputBytes.toString().trim(); // Convert to String and trim
            process.close();

            // Check if the HTTP response code is 200
            callback(output == "200");
        } catch (e:Dynamic) {
            callback(false); // If an exception occurs, assume no internet connection
        }
        #end
    }
}