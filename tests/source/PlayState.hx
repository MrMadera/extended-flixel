package;

import flixel.net.InternetCheck;
import flixel.text.FlxText;
import flixel.extended.ExtendedSprite;
import flixel.extended.ExtendedText;
import flixel.FlxState;

import flixel.net.downloads.GoogleDriveDownloader;

class PlayState extends FlxState
{
	var sprite:ExtendedSprite;
	override public function create()
	{
		super.create();

		sprite = new ExtendedSprite(0, 0, 'assets/images/BOYFRIEND.png', true);
		sprite.addSparrowAnimation('idle', 'BF idle dance', 24, true);
		sprite.playAnim('idle');
		sprite.screenCenter();
		sprite.shakeObject(3, 2);
		sprite.doTween({alpha: 0}, 2, {type: PINGPONG});
		add(sprite);

		InternetCheck.execute(function(success:Bool)
		{
			if(!success) return;

			var txt = new ExtendedText(0, 600, 0, "Internet connection avaible", 16);
			txt.color = 0xFF088026;
			txt.screenCenter(X);
			txt.setBold(true);
			txt.setItalic(true);
			add(txt);

			GoogleDriveDownloader.extension = 'zip';
			GoogleDriveDownloader.autoUnzip = true;
			//GoogleDriveDownloader.customOutputPath = 'C:/Users/User/Desktop';
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
			//new GoogleDriveDownloader("https://drive.google.com/file/d/1aoQrga81pQQBM0zgKp8EhcEhn2iyDh7g/view?usp=sharing", "test_file");
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if(sprite.isOverlaping(true, true))
		{
			#if debug trace('You\'re overlaping bf!'); #end
		}
	}
}
