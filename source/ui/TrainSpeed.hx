package ui;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class TrainSpeed extends FlxText
{
	
	var last_speed:Float;

	public function new() 
	{
		super(0, FlxG.height - 48, FlxG.width);
		setFormat(null, 16, 0xffffff, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0x000000);
		borderSize = 3;
		angle = -5;
		FlxTween.tween(this, {angle:5}, 3, {ease:FlxEase.sineInOut, type:FlxTween.PINGPONG});
		FlxTween.tween(scale, {x:1.2}, 4, {ease:FlxEase.sineInOut, type:FlxTween.PINGPONG});
		FlxTween.tween(scale, {y:1.2}, 6, {ease:FlxEase.sineInOut, type:FlxTween.PINGPONG});
		
		scrollFactor.set();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (last_speed > PlayState.i.train_speed)
			borderColor = 0xffff004d;
		else if (PlayState.i.train_speed > 1000)
			borderColor = new FlxRandom().color();
		else
			borderColor = 0xff00e756;
		
		text = "" + Std.int(PlayState.i.train_speed) + "km/h!";
		super.update(elapsed);
		
		last_speed = PlayState.i.train_speed;
	}
	
	
	
}