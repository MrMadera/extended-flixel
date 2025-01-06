# HOW TO USE DOWNLOADERS

## GOOGLE DRIVE
To use google drive downloader, you have to instance a new **GoogleDriveDownloader** and put inside two parameters
 - URL: You must use the normal url (example url: https://docs.google.com/document/d/1PbiTneQ-HJFpDc6EQ8LxcsjFz3UNv3C1OElg6sdUaT4/edit?usp=sharing) The url must start with "(https://drive.google.com/file/d/)"
 - File name: The name of the output file

### EXAMPLE
Then instance the downloader:
```haxe
new GoogleDriveDownloader('https://docs.google.com/document/d/1PbiTneQ-HJFpDc6EQ8LxcsjFz3UNv3C1OElg6sdUaT4/edit?usp=sharing', 'my_download');
// Remember that urls which do not start with /file/d won't work! 
```

After that you must include the extension of the file 
> WARNING: If you do not include the extension, the output file will be a normal file!

```haxe
GoogleDriveDownloader.extension = 'zip'; //my_download.zip
new GoogleDriveDownloader('https://docs.google.com/document/d/1PbiTneQ-HJFpDc6EQ8LxcsjFz3UNv3C1OElg6sdUaT4/edit?usp=sharing', 'my_download');
```

### EXTRA
If you're downloading a .zip file, you can automatically unzip the file
> This process depending on the zip content, may take a few minutes

```haxe
GoogleDriveDownloader.extension = 'zip';
GoogleDriveDownloader.autoUnzip = true; // this will unzip your file when the download is finished
new GoogleDriveDownloader('https://docs.google.com/document/d/1PbiTneQ-HJFpDc6EQ8LxcsjFz3UNv3C1OElg6sdUaT4/edit?usp=sharing', 'my_download');
```

You can also set a custom path for the download
```haxe
GoogleDriveDownloader.extension = 'zip';
GoogleDriveDownloader.autoUnzip = true;
GoogleDriveDownloader.customOutputPath = 'C:/Users/User/Desktop'; // the output file will be located in the desktop
new GoogleDriveDownloader('https://docs.google.com/document/d/1PbiTneQ-HJFpDc6EQ8LxcsjFz3UNv3C1OElg6sdUaT4/edit?usp=sharing', 'my_download');
```
You can add some callbacks for some functions
```haxe
GoogleDriveDownloader.autoUnzip = true;
GoogleDriveDownloader.customOutputPath = 'C:/Users/User/Desktop';
GoogleDriveDownloader.onSuccess = function()
{
    trace('Download completed!');
}
GoogleDriveDownloader.onCancel = function()
{
    trace('Download canceled!');
}
GoogleDriveDownloader.onZipSuccess = function()
{
    trace('Unzip process completed!');
}
new GoogleDriveDownloader('https://docs.google.com/document/d/1PbiTneQ-HJFpDc6EQ8LxcsjFz3UNv3C1OElg6sdUaT4/edit?usp=sharing', 'my_download');
```