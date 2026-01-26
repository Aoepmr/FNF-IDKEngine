package funkin.editors.content;

import flixel.math.FlxMath;
import flixel.math.FlxPoint;

/*
	Vertical slider for the chart editor
	Top = min, Bottom = max
 */
class FunkinSlider extends FlxSpriteGroup
{
	public var min:Float = 0;
	public var max:Float = 1;

	private var _value:Float = 0;
	private var visualValue:Float = 0;

	public var value(get, set):Float;

	public var onChange:Float->Void;

	public var track:FlxSprite;
	public var thumb:FlxSprite;

	// visual things
	public var showTrack:Bool = true;
	public var inactiveAlpha:Float = 0.5;
	public var activeAlpha:Float = 1.0;

	public var lerpSpeed:Float = 0;

	var dragging:Bool = false;
	var sliderHeight:Int;
	var sliderWidth:Int;
	var thumbWidth:Int;
	var thumbHeight:Int;

	public function new(x:Float, y:Float, height:Int, min:Float = 0, max:Float = 1, ?trackWidth:Int = 6, ?thumbW:Int = 10, ?thumbH:Int = 10)
	{
		super(x, y);

		this.min = min;
		this.max = max;
		this.sliderWidth = trackWidth;
		this.thumbWidth = thumbW;
		this.thumbHeight = thumbH;
		this.sliderHeight = height;

		track = new FlxSprite(x, y).makeGraphic(sliderWidth, sliderHeight, 0xFF666666);
		add(track);

		thumb = new FlxSprite(x, y).makeGraphic(thumbWidth, thumbHeight, 0xFFAAAAAA);
		centerThumbX();
		add(thumb);

		value = min;
		visualValue = _value;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		track.visible = showTrack;

		var mouseOver:Bool = FlxG.mouse.overlaps(thumb, camera) || FlxG.mouse.overlaps(track, camera);

		if (mouseOver && FlxG.mouse.justPressed)
			dragging = true;

		var active:Bool = dragging || mouseOver;
		thumb.alpha = FlxMath.lerp(thumb.alpha, active ? activeAlpha : inactiveAlpha, elapsed * 10);

		if (dragging)
		{
			if (FlxG.mouse.pressed)
			{
				var mousePos:FlxPoint = FlxG.mouse.getPositionInCameraView(camera);
				var my:Float = mousePos.y - track.y;
				var t:Float = FlxMath.bound(my / (sliderHeight - thumbHeight), 0, 1);
				value = min + t * (max - min);
			}
			else
			{
				dragging = false;
			}
		}

		if (lerpSpeed > 0)
			visualValue = FlxMath.lerp(visualValue, _value, elapsed * lerpSpeed);
		else
			visualValue = _value;

		updateThumbPosition(visualValue);
	}

	function get_value():Float
	{
		return _value;
	}

	function set_value(v:Float):Float
	{
		var old:Float = _value;
		_value = FlxMath.bound(v, min, max);

		if (old != _value && onChange != null)
			onChange(_value);

		return _value;
	}

	function updateThumbPosition(v:Float):Void
	{
		var range:Float = max - min;
		var t:Float = (range != 0) ? (v - min) / range : 0;
		thumb.y = track.y + t * (sliderHeight - thumbHeight);
	}

	public function setThumbSize(w:Int, h:Int):Void
	{
		thumbWidth = w;
		thumbHeight = h;
		thumb.makeGraphic(w, h, 0xFFAAAAAA);
		centerThumbX();
		updateThumbPosition(visualValue);
	}

	function centerThumbX():Void
	{
		thumb.x = track.x - (thumbWidth - sliderWidth) / 2;
	}
}
