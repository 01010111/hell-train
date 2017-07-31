package ui;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author ...
 */
class Bullets extends FlxSpriteGroup
{
	
	public var can_shoot:Bool = true;
	var loaded_bullets:Int = 6;
	var angle_delta:Float = -15;
	var reload_timer:Int = 10;
	
	var x_o:Float = 256;
	var y_o:Float = FlxG.height - 32;
	
	public function new() 
	{
		super();
		for (i in 0...6)
			add(new Bullet(FlxPoint.get(x_o + i * 10, y_o)));
		scrollFactor.set();
		FlxTween.tween(this, {angle_delta:15}, 1, {ease:FlxEase.sineInOut, type:FlxTween.PINGPONG});
	}
	
	override public function update(elapsed:Float):Void 
	{
		for (i in 0...6)
		{
			members[i].visible = true;
			var _a = 0.0;
			var _s = 1;
			if (i == loaded_bullets - 1)
			{
				_s = 2;
				_a = angle_delta;
			}
			else if (i >= loaded_bullets)
			{
				members[i].visible = false;
			}
			
			members[i].scale.x += (_s - members[i].scale.x) * 0.1;
			members[i].scale.y += (_s - members[i].scale.y) * 0.1;
			members[i].angle += (_a - members[i].angle) * 0.1;
			
			members[i].color = can_shoot ? 0xffffffff : 0xffff004d;
		}
		
		if (!can_shoot)
		{
			if (reload_timer == 0)
			{
				FlxG.sound.play("assets/sounds/reload.wav");
				loaded_bullets += 1;
				reload_timer = 10;
				if (loaded_bullets == 6)
				{
					FlxG.sound.play("assets/sounds/yes.wav");
					can_shoot = true;
				}
			}
			else
				reload_timer--;
		}
		
		super.update(elapsed);
	}
	
	public function remove_bullet()
	{
		loaded_bullets -= 1;
		if (loaded_bullets == 0)
			can_shoot = false;
	}
	
}

class Bullet extends FlxSprite
{
	
	public function new(_p:FlxPoint)
	{
		super(_p.x, _p.y, "assets/images/bullet_ui.png");
		scrollFactor.set();
	}
	
}