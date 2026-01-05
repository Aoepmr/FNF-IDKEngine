package flixel.system.ui;

#if FLX_SOUND_SYSTEM
import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Assets;
#if flash
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
#end

/**
 * The flixel sound tray, the little volume meter that pops down sometimes.
 * Accessed via `FlxG.game.soundTray` or `FlxG.sound.soundTray`.
 */
class FlxSoundTray extends Sprite
{
	/**
	 * Because reading any data from DisplayObject is insanely expensive in hxcpp, keep track of whether we need to update it or not.
	 */
	public var active:Bool;

	/**
	 * Helps us auto-hide the sound tray after a volume change.
	 */
	var _timer:Float;

	/**
	 * Helps display the volume bars on the sound tray.
	 */
	var _bars:Array<Bitmap>;

	/**
	 * How wide the sound tray background is.
	 */
	var _width:Int = 80;

	var _defaultScale:Float = 2.0;

	var _isHiding:Bool = false;

	/**The sound used when increasing the volume.**/
	public var volumeUpSound:String = "soundtray/Volup";

	/**The sound used when decreasing the volume.**/
	public var volumeDownSound:String = "soundtray/Voldown";

	/**The sound used when volume is maxed.**/
	public var volumeMaxSound:String = "soundtray/VolMAX";

	/**Whether or not changing the volume should make noise.**/
	public var silent:Bool = false;

	var bg:Bitmap;
	var graphicScale:Float = 0.3;
	var lerpYPos:Float = 0;
	var alphaTarget:Float = 0;

	/**
	 * Sets up the "sound tray", the little volume meter that pops down sometimes.
	 */
	@:keep
	public function new()
	{
		super();

		visible = false;
		active = false;
		alpha = 0;

		// funky stuff
		bg = new Bitmap(Assets.getBitmapData(Paths.getPath("images/soundtray/volumebox.png")));
		bg.scaleX = graphicScale;
		bg.scaleY = graphicScale;
		bg.smoothing = true;
		addChild(bg);

		var backingBar:Bitmap = new Bitmap(Assets.getBitmapData(Paths.getPath("images/soundtray/bars_10.png")));
		backingBar.x = 9;
		backingBar.y = 5;
		backingBar.scaleX = graphicScale;
		backingBar.scaleY = graphicScale;
		backingBar.smoothing = true;
		backingBar.alpha = 0.4;
		addChild(backingBar);

		_bars = [];

		for (i in 1...11)
		{
			var bar:Bitmap = new Bitmap(Assets.getBitmapData(Paths.getPath("images/soundtray/bars_" + i + ".png")));
			bar.x = 9;
			bar.y = 5;
			bar.scaleX = graphicScale;
			bar.scaleY = graphicScale;
			bar.smoothing = true;
			addChild(bar);
			_bars.push(bar);
		}

		y = -height;
		lerpYPos = y;

		screenCenter();
	}

	/**
	 * This function updates the soundtray object.
	 */
	public function update(MS:Float):Void
	{
		var elapsed:Float = MS / 1000;


		// Smooth movement
		y += (lerpYPos - y) * Math.min(elapsed * 8, 1);
		alpha += (alphaTarget - alpha) * Math.min(elapsed * 6, 1);

		// Timer logic
		if (_timer > 0)
		{
			_timer -= elapsed;
		}
		else if (!_isHiding)
		{
			_isHiding = true;
			lerpYPos = -height - 10;
			alphaTarget = 0;
		}

		if (_isHiding && y <= -height && alpha <= 0.01)
		{
			visible = false;
			active = false;
			_isHiding = false;

			#if FLX_SAVE
			if (FlxG.save.isBound)
			{
				FlxG.save.data.mute = FlxG.sound.muted;
				FlxG.save.data.volume = FlxG.sound.volume;
				FlxG.save.flush();
			}
			#end
		}
	}

	/**
	 * Makes the little volume tray slide out.
	 *
	 * @param	up Whether the volume is increasing.
	 */
	public function show(up:Bool = false):Void
	{
		_isHiding = false;
		var globalVolume:Int = Math.round(FlxG.sound.volume * 10);
		if (FlxG.sound.muted)
			globalVolume = 0;

		if (!silent)
		{
			var soundPath:String;

			if (globalVolume >= 10 && up)
				soundPath = volumeMaxSound;
			else
				soundPath = up ? volumeUpSound : volumeDownSound;

			//using paths for mods compatibility
			var sound = Paths.sound(soundPath);
			if (sound != null)
				FlxG.sound.load(sound).play();
		}

		_timer = 1;
		lerpYPos = 10;
		alphaTarget = 1;
		visible = true;
		active = true;

		for (i in 0..._bars.length)
			_bars[i].visible = i < globalVolume;
	}

	public function screenCenter():Void
	{
		scaleX = _defaultScale;
		scaleY = _defaultScale;

		var fixedWidth:Float = bg.bitmapData.width * graphicScale * _defaultScale;
		x = (Lib.current.stage.stageWidth - fixedWidth) * 0.5 - FlxG.game.x;
	}
}
#end
