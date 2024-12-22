package flixel.net;

import sys.net.Host;
import haxe.Http;

class InternetCheck
{
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
        Sys.sleep(2);
    }
}