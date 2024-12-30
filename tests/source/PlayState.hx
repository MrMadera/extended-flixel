package;

import flixel.net.InternetCheck;
import flixel.text.FlxText;
import flixel.extended.ExtendedSprite;
import flixel.extended.ExtendedText;
import flixel.particles.ParticleSystem;
import flixel.FlxState;

import flixel.net.downloads.GoogleDriveDownloader;

class PlayState extends FlxState
{
	var sprite:ExtendedSprite;
	var particles:ParticleSystem;

	override public function create()
	{
		super.create();

		sprite = new ExtendedSprite(0, 0, 'assets/images/BOYFRIEND.png', true);
		sprite.addSparrowAnimation('idle', 'BF idle dance', 24, true);
		sprite.playAnim('idle');
		sprite.screenCenter();
		sprite.shakeObject(0.05, 2, XY);
		sprite.doTween({alpha: 0}, 2, {type: PINGPONG});
		add(sprite);

		InternetCheck.execute(function(success:Bool)
		{
			if(!success) return;

			var txt = new ExtendedText(0, 600, 0, "Internet connection avaible", 16);
			txt.setTextColor(0xFF088026);
			txt.screenCenter(X);
			txt.setBold(true);
			txt.addMarkup("Internet connection /avaible/", 0xFF22C77A, '/');
			txt.setUnderline(3, 0xFF22C77A);
			txt.setItalic(true);
			txt.setAlignment('left');
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

		particles = new ParticleSystem(0, 0);
		particles.particlesNum = 2;
		particles.generateParticles('assets/images/demoParticle.png');
		add(particles);
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
