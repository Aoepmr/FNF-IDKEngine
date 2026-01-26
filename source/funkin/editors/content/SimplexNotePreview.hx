package funkin.editors.content;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/*
	W.I.P
	A preview of the notes in the chart editor
	Based on VSlice Note Preview
	Idk why is simplex, just sounds cool for me :v
 */
class SimplexNotePreview extends FlxSprite
{
	public var noteWidth:Int = 5;
	public var noteHeight:Int = 1;
	public var previewHeight:Int;

	public var bgColor:FlxColor = 0xFF606060;
	public var leftColor:FlxColor = 0xFFFF22AA;
	public var downColor:FlxColor = 0xFF00EEFF;
	public var upColor:FlxColor = 0xFF00CC00;
	public var rightColor:FlxColor = 0xFFCC1111;

	public function new(x:Float, y:Float, height:Int)
	{
		super(x, y);
		previewHeight = height;
        // Make sure that the antialiasing is disabled
        antialiasing = false;

		makeGraphic(noteWidth * 8, previewHeight, bgColor);
	}

	public function clear():Void
	{
		drawRect(0, 0, Std.int(width), previewHeight, bgColor);
	}

	public function addNote(dir:Int, mustHit:Bool, timeMs:Float, songLengthMs:Float):Void
	{
		var color:FlxColor = switch (dir)
		{
			case 0: leftColor;
			case 1: downColor;
			case 2: upColor;
			case 3: rightColor;
			default: FlxColor.WHITE;
		};

		var noteX:Float = noteWidth * dir;
		if (!mustHit)
			noteX += noteWidth * 4;

		var noteY:Int = Std.int(FlxMath.remapToRange(timeMs, 0, songLengthMs, 0, previewHeight));

		drawRect(noteX, noteY, noteWidth, noteHeight, color);
	}

	public function eraseNote(dir:Int, mustHit:Bool, timeMs:Float, songLengthMs:Float):Void
	{
		var noteX:Float = noteWidth * dir;
		if (!mustHit)
			noteX += noteWidth * 4;

		var noteY:Int = Std.int(FlxMath.remapToRange(timeMs, 0, songLengthMs, 0, previewHeight));

		drawRect(noteX, noteY, noteWidth, noteHeight, bgColor);
	}

	inline function drawRect(x:Float, y:Float, w:Int, h:Int, color:FlxColor):Void
	{
		FlxSpriteUtil.drawRect(this, x, y, w, h, color);
	}
}
