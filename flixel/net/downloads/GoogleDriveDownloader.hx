package flixel.net.downloads;

import flixel.math.FlxMath;
import haxe.io.Eof;
import haxe.io.Error;
import haxe.Http;
import sys.io.File;
import sys.ssl.Socket;
import sys.net.Host;
import sys.thread.Thread;
import htmlparser.HtmlDocument;
import haxe.zip.Uncompress;
import sys.io.FileOutput;
import sys.FileSystem;
import haxe.zip.Reader;
import haxe.zip.Entry;

// Direct link:
//https://download1326.mediafire.com/bxesialfjqvgNZFE0xL0GqPEisM1mE5dhDS1-zzNhDem5gRYS_H9SAAX31svImmMS161gRg8tZTDOfUiJFrte7q-S-giRrOMrPDOmpLco7VLv0xkmqcKmRO19P_rKHuRWCtpz-on0nBbXkduIvc5t97pp55rqQGFEwNm-mT8J08/teq6fgks0mzhnm4/bin.zip

class GoogleDriveDownloader 
{
    public function new(url:String, _fileName:String) 
    {
        Thread.create(function() 
        {
            fetchGoogleDriveData(url);
        });
        fileName = _fileName;
        trace("Fetching data...");
    }

    /**
     * While downloading, this variable will be `true`
    **/
    public static var isDownloading:Bool = false;
    /**
     * Socket variable. Main handler of downloads
    **/
    public static var socket:Socket;

    /**
     * Domain of the URL
    **/
    public static var domain:String;
    /**
     * Path of the URL
     * The path is the part which come after the domain.
     * e.g. https://download1326.mediafire.com`/bxesialfjqvgNZFE0xL0GqPEisM1mE5dhDS1...` is the path, the other part 
    **/
    public static var path:String;

    /**
     * The current amount of bytes written during the download
    **/
    public static var bytesDownloaded:Float;
    
    /**
     * The output file
    **/
	public static var file:FileOutput;

    /**
     * The extension of the file
    **/
    public static var extension:String;

    /**
     * The name of the output file
    **/
    public static var fileName:String;

    /**
     * String telling you about the current status of the download
    **/
    public static var downloadStatus:String;

    /**
     * The default path of the download (downloads folder in the .exe path)
    **/
    private static var defaultOutputPath:String = '';
    /**
     * The custom path. If equals `''`, the file will be downloaded in the default path
    **/
    public static var customOutputPath:String = '';
    /**
     * Custom path where you can put your unzipped stuff. If equals `''`, stuff will be unzipped in the `customOutputPath` or `defaultOutputPath`
    **/
    public static var unZipCustomPath:String = '';

    /**
     * If download is complete, this funcion will be executed
    **/
    public static var onSuccess:Void -> Null<Void>;
    /**
     * If download is canceled, this funcion will be executed
    **/
    public static var onCancel:Void -> Null<Void>;
    /**
     * If unzip process is completed, this funcion will be executed
    **/
    public static var onZipSuccess:Void -> Null<Void>;

    /**
     * Function which downloads files from an url
     @param url the DIRECT url of the file
    **/
    public static function downloadFile(url:String)
    {
        downloadStatus = 'Starting...';
        canCancelDownloads = true;
        canceledDownload = false;

        socket = new Socket();

        var oldoutputFilePath:String = Sys.programPath();

        var index = oldoutputFilePath.lastIndexOf("\\");

        defaultOutputPath = oldoutputFilePath.substr(0, index);
        trace('Path before: ' + defaultOutputPath);

        if(customOutputPath != '')
        {
            defaultOutputPath = customOutputPath;
        }
        
        defaultOutputPath += '/downloads/' + fileName + '.download'/* + extension*/; // not yet!!!

        isDownloading = true;
        
        setDomains(url);

        trace('PATH: ' + defaultOutputPath + ', EXTENSION: ' + extension);

		var headers:String = "";
		headers += '\nHost: ${domain}:443';
		headers += '\nUser-Agent: haxe';
		headers += '\nConnection: close';
        trace('Headers: ' + headers);

		socket.setTimeout(5);
		socket.setBlocking(true);

        var tries:Int = 0;
        while(isDownloading)
        {
            tries++;
            try
            {
                // Lil guide cuz im so idiot to undestand this without my comments :(
    
                // Connect to the server
                downloadStatus = 'Connecting...';
                socket.connect(new Host(domain), 443);
                trace('Successfully connected to Network!');
                
                // Write shit to the server so i can download stuff
                socket.write('GET ${path} HTTP/1.1${headers}\n\n');
    
                // The http status shit that sucks sjak fasjfkl 
        
                var httpStatus:String = null;
                httpStatus = socket.input.readLine();
                httpStatus = StringTools.ltrim(httpStatus.substr(httpStatus.indexOf(" ")));
        
                if (httpStatus == null || StringTools.startsWith(httpStatus, "4") || StringTools.startsWith(httpStatus, "5")) 
                {
                    if(StringTools.startsWith(httpStatus, "404")) downloadStatus = 'Network error! The file does not exist';
                    trace('Network error! - $httpStatus');
                    return;
                }
                trace('GET method successfully done!');

				break;
            }
            catch(e)
            {
                if(tries <= 4)
                {
                    downloadStatus = 'Retrying...';
                    trace('Network Error! ' + e + ', Retrying... ' + tries);
                }
                else
                {
                    trace('Many tries! Network has been closed...');
                    socket.close();
                    isDownloading = false;
                    return;
                }

                Sys.sleep(1);
            }
        }

        // Creating the direcory in case it doesn't exist
        var downloadOutput = StringTools.replace(defaultOutputPath, '/' + fileName + '.download'/* + extension*/, ''); 
        if(!FileSystem.exists(downloadOutput))
        {
            FileSystem.createDirectory(downloadOutput);
        }

        // Instance the file
        try
        {
            downloadStatus = 'Creating file...';
            if(!FileSystem.exists(defaultOutputPath))
            {
                trace('path $defaultOutputPath does not exist!');
                file = File.append(defaultOutputPath, true);
                trace('File created');
            }
            else
            {
                trace('path $defaultOutputPath exists!');
                FileSystem.deleteFile(defaultOutputPath);
                trace('Old file deleted!');
                file = File.append(defaultOutputPath, true);
                trace('File created');
            }
        }
        catch(exc)
        {
            downloadStatus = 'Error creating file...';
            file = null;
            trace('Error creating file!');
            return;
        }

        // Now let's get the headers
        var headers:Map<String, String> = new Map<String, String>();
        while(isDownloading && !canceledDownload)
        {
            downloadStatus = 'Getting headers...';
			var read:String = socket.input.readLine();
			if (StringTools.trim(read) == "") 
            {
				break;
			}
			var splitHeader = read.split(": ");
            headers.set(splitHeader[0].toLowerCase(), splitHeader[1]);
            trace('Headers map: ' + headers);

            #if debug
                var oldoutputFilePath:String = Sys.programPath();
                var index = oldoutputFilePath.lastIndexOf("\\");
                var defaultOutputPathDebug:String = oldoutputFilePath.substr(0, index);
                
                defaultOutputPathDebug += '/downloads/headers.txt';

                File.saveContent(defaultOutputPathDebug, headers.toString());
            #end
        }
		if (headers.exists("content-length")) // take max bytes length
        {
			totalBytes = Std.parseFloat(headers.get("content-length"));
            trace('TOTAL BYTES: ' + totalBytes);
		}

		//var buffer:haxe.io.Bytes = haxe.io.Bytes.alloc(1024);
        var buffer:haxe.io.Bytes = haxe.io.Bytes.alloc(65536);
		var bytesWritten:Int = 1;
        if(totalBytes > 0)
        {
            while(bytesDownloaded < totalBytes && isDownloading && !canceledDownload)
            {
                try
                {
                    downloadStatus = 'Downloading...';
                    bytesWritten = socket.input.readBytes(buffer, 0, buffer.length);
                    file.writeBytes(buffer, 0, bytesWritten);
                    bytesDownloaded += bytesWritten;
                    //trace('Downloading! ' + loadedBytes(bytesDownloaded) + '/' + loadedBytes(totalBytes));
                    Sys.print('\rDownloading! ' + loadedBytes(bytesDownloaded) + '/' + loadedBytes(totalBytes));
                }
                catch (e:Dynamic) 
                {
                    if (e is Eof || e == Error.Blocked) 
                    {
                        // Ignoring eof & error
                        continue;
                    }
                    throw e;
                }
            }

            canCancelDownloads = false;
            if(canceledDownload)
            {
                // If download is canceled

                downloadStatus = 'Cancelling...';
                trace('Cancelling...');
                trace('Closing network...');
                if(socket != null) socket.close();
                socket = null;

                if(file != null) file.close();
                file = null;

                try 
                {
                    FileSystem.deleteFile(defaultOutputPath);
                    trace('It\'s cancelled so we gotta delete the file :(');
                }

                if(onCancel != null) onCancel();

                resetInfo();
            }
            else
            {
                // If download is completed

                trace('Download complete!');
                trace('Closing network...');
                if(socket != null) socket.close();
                socket = null;

                if(file != null) file.close();
                file = null;

                try
                {
                    var trueFile = StringTools.replace(defaultOutputPath, '.download', '.' + extension);
                    if(!FileSystem.exists(trueFile))
                    {
                        FileSystem.rename(defaultOutputPath, trueFile);
                    }
                    else
                    {
                        FileSystem.deleteFile(trueFile);
                        trace('Deleting old .$extension');
                        FileSystem.rename(defaultOutputPath, trueFile);
                    }
                }

                if(onSuccess != null) onSuccess();

                checkFormat();
                resetInfo();
            }
        }
        else
        {
			while (bytesWritten > 0 && !canceledDownload) {
                trace('Written bytes: $bytesWritten');
				try 
                {
					bytesWritten = Std.parseInt('0x' + socket.input.readLine());
					file.writeBytes(socket.input.read(bytesWritten), 0, bytesWritten);
					bytesDownloaded += bytesWritten;
                    trace('Downloading! Starting to download content: ' + bytesDownloaded);
				}
				catch (e:Dynamic) 
                {
					if (e is Eof || e == Error.Blocked) 
                    {
						// Ignoring eof & error
						continue;
					}
					throw e;
				}
			}
        }
    }

    /**
     * The total amount of bytes of the file
    **/
    public static var totalBytes:Float = 0;

    //Get google drive data

    /**
     * Function which gets the direct url from a normal url
     @param url the normal url
    **/
    public static function fetchGoogleDriveData(url:String)
    {
		var id = url.substr("https://drive.google.com/file/d/".length).split("/")[0];
		var newURL = 'https://drive.usercontent.google.com/download?id=$id&export=download&confirm=t';
        trace('NEW URL: ' + newURL);
        Thread.create(function() 
        {
            downloadFile(newURL);
        });
    }

    /**
     * During unzipping, this variable will be `true`
    **/
    public static var unzipping:Bool = false;
    /**
     * If `true`, it will start the unzip process when the download finish
    **/
    public static var autoUnzip:Bool = false;

    /**
     * Function which uncompress .zip files
    **/
    public static function unZip(path:String)
    {
        trace('Starting unzip process!');

        unzipping = true;

        var savePath = StringTools.replace(path, '.zip', '/');
        if(unZipCustomPath != null && unZipCustomPath != '')
        {
            try
            {
                savePath = unZipCustomPath;
                if(!FileSystem.exists(haxe.io.Path.directory(unZipCustomPath)))
                {
                    FileSystem.createDirectory(unZipCustomPath);
                }
            }
            catch(exc)
            {
                trace('Unzipping process in your custom path has failed!');
            }
        }
        else
        {
            if(!FileSystem.exists(haxe.io.Path.directory(savePath)))
            {
                FileSystem.createDirectory(savePath);
            }
        }

        var file = File.read(path);
        trace('File read!');

        downloadStatus = 'Reading file... (may take a few minutes)';

        var filesInZip = Reader.readZip(file);
        file.close();

        var bytes:haxe.io.Bytes = null;
        try
        {
            var zipBytesWritten:Float = 1;
            for (entry in filesInZip) 
            {
                //Sys.print('\rProcessing entry: ${entry.fileName}');
                //Sys.println('');
                if (StringTools.endsWith(entry.fileName, '/')) {
                    try {
                        FileSystem.createDirectory(savePath + entry.fileName);
                    } catch(exc:Dynamic) {
                        trace('Error creating directory ${entry.fileName} - ${exc.message}');
                    }
                } else {
                    try {
                        zipBytesWritten += entry.fileSize;
                        downloadStatus = 'Unzipping... (${loadedBytes(zipBytesWritten)})';
                        Sys.print('\rWritten bytes: ${loadedBytes(zipBytesWritten)}');
                        bytes = Reader.unzip(entry);
                        var f = File.write(savePath + entry.fileName, true);
                        f.write(bytes);
                        f.close();
                    } catch(exc:Dynamic) {
                        trace('Error processing entry ${entry.fileName} - ${exc.message}');
                    }
                }
            }
        }
        catch(exc)
        {
            trace('Zip error! - $exc');
            trace('Stack trace: ${haxe.CallStack.toString(haxe.CallStack.exceptionStack())}');
            trace('Stopped!');
            downloadStatus = 'Zip error! - $exc';
            return;
        }

        trace('Finished unzipped!');
        downloadStatus = 'Done!';
        trace('Saved!');
        if(onZipSuccess != null) onZipSuccess();
        unzipping = false;
    }

    /**
     * Set `domain` and `path` from the direct url
    **/
    public static function setDomains(url:String)
    {
        // example: https://drive.google.com/file/d/1sFS2MCOhDW8WEcyhZnx2VM1iJK6a9ByL/view?usp=sharing

        // domain
        var fdom:String = url.substr(8, 28);
        domain = fdom; //drive.usercontent.google.com

        // path
        var fpath = url.substr(36, url.length);
        trace('path???',fpath);
        path = fpath;
    }

    private static function checkFormat()
    {
        if(extension == 'zip' && autoUnzip)
        {
            defaultOutputPath = StringTools.replace(defaultOutputPath, '.download', '.' + extension); //defaultOutputPath += '/downloads/' + fileName + '.' + extension;
            trace(defaultOutputPath);
            unZip(defaultOutputPath);
        }
        else downloadStatus = 'Download complete!';
    }

    private static function resetInfo()
    {
        if (file != null)
            file.close();
        extension = null;
        isDownloading = false;
        domain = '';
        path = '';
        bytesDownloaded = 0;
        canceledDownload = false;
        //canCancelDownloads = true;
    }

    public static function loadedBytes(b:Float):String
    {
        if(b > 1024000000) return FlxMath.roundDecimal(b / 1024000000, 2) + "GB";
        else if (b > 1024000) return FlxMath.roundDecimal(b / 1024000, 2) + "MB";
        else if (b > 1024) return FlxMath.roundDecimal(b / 1024, 0) + "kB";
        else return FlxMath.roundDecimal(b, 0) + "B";
    }

    /**
     * If download is canceled, this will turn `true`
    **/
    public static var canceledDownload:Bool = false;

    /**
     * If download is finished, you cannot delete the file and cancel the download
    **/
    public static var canCancelDownloads:Bool = true;
}