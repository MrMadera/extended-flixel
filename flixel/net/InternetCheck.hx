package flixel.net;

import sys.net.Host;

class InternetCheck
{
    public static function execute()
    {
        try 
        {
            @:privateAccess
            var host = Host.resolve("google.com");
            trace('Connected to internet: ${(host != null)}');
        }
        catch(exc)
        {
            trace('Not connected to internet.');
        }
    }
}