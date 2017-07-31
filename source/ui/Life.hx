package ui;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author ...
 */
class Life extends FlxSpriteGroup
{
	
	var angle_delta = -15;
	
	public function new() 
	{
		super();
		for (i in 0...9)
		{
			var b = i == 0;
			add(new LifeBit(b, i));
		}
		scrollFactor.set();
		
		FlxTween.tween(this, {angle_delta:15}, 1, {ease:FlxEase.sineInOut, type:FlxTween.PINGPONG});
	}
	
	override public function update(elapsed:Float):Void 
	{
		for (i in 0...9)
		{
			members[i].visible = i == 0 && PlayState.i.conductor.alive || PlayState.i.conductor.bodies >= i;
			
			var _a = 0.0;
			var _s = 1;
			if (i == PlayState.i.conductor.bodies)
			{
				_s = 2;
				_a = angle_delta;
			}
			
			members[i].scale.x += (_s - members[i].scale.x) * 0.1;
			members[i].scale.y += (_s - members[i].scale.y) * 0.1;
			members[i].angle += (_a - members[i].angle) * 0.1;
		}
		
		super.update(elapsed);
	}
	
}

class LifeBit extends FlxSprite
{
	
	var xo = 16;
	var yo = FlxG.height - 32;
	var xi = 10;
	
	public function new(_heart:Bool, _x:Int)
	{
		super(xo + xi * _x, yo);
		loadGraphic("assets/images/life.png", true, 9, 8);
		animation.frameIndex = _heart ? 0 : 1;
	}
	
}