package objects;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import objects.EnemySpawner.Grunt;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class EnemySpawner extends FlxTypedGroup<Grunt>
{
	
	var timer_amt = 10.0;
	var wave:Int;
	var enemies_per_wave:Int = 1;
	
	public function new() 
	{
		super();
		new FlxTimer().start(20, fire);
	}
	
	public function fire(?t:FlxTimer)
	{
		wave++;
		if (wave % 4 == 0 && enemies_per_wave < 8)
			enemies_per_wave++;
		for (i in 0...enemies_per_wave)
		{
			if (countLiving() < 8)
				add(new Grunt());
		}
		//FlxG.camera.flash();
		new FlxTimer().start(timer_amt * ZMath.randomRange(0.5, 1.5), fire);
	}
	
}

class Grunt extends FlxSprite
{
	
	var speed:Float = 100;
	public var eating:Bool = false;
	var eat_timer:Int = 240;
	var target:Passenger;
	var hunger:Int = 240;
	
	public function new()
	{
		super(ZMath.randomRangeInt(0, 4) * FlxG.width + ZMath.randomRange(48, FlxG.width - 64), -64);
		//super(get_player_pos().x, -64);
		loadGraphic("assets/images/grunts.png", true, 48, 32);
		var _t = ZMath.randomRangeInt(0, 2) * 9;
		animation.add('eat',  [0 + _t, 1 + _t, 2 + _t], 12);
		animation.add('run',  [3 + _t, 4 + _t, 4 + _t, 5 + _t, 6 + _t, 7 + _t, 7 + _t, 8 + _t], 15);
		animation.add('jump', [7 + _t]);
		animation.add('fall', [6 + _t]);
		setSize(14, 20);
		offset.set(17, 12);
		acceleration.y = 600;
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
	}
	
	override public function update(elapsed:Float):Void 
	{
		animations();
		
		if (hunger > 0)
			hunger--;
		
		if (!eating)
		{
			velocity.x = facing == FlxObject.LEFT ? -speed : speed;
			if (justTouched(FlxObject.FLOOR))
				calculate_direction();
			else if (justTouched(FlxObject.WALL) || x <= 16 || x > 1540)
				flip_direction();
			else if (isOnScreen() && Math.abs(getMidpoint().y - get_player_pos().y) < 32 && PlayState.i.conductor.alive)
				chase_player();
			if (get_player_pos().y <= getMidpoint().y 
				&& !PlayState.i.train.overlapsPoint(FlxPoint.get(getMidpoint().x + FlxMath.signOf(velocity.x) * 16, getMidpoint().y + 16)) 
				&& isTouching(FlxObject.FLOOR))
				jump();
			
			if (hunger == 0)
			{
				FlxG.overlap(PlayState.i.vips, this, feast);
			}
		}
		else
		{
			if (Math.random() > 0.9)
				PlayState.i.blood_splatter(this, 2);
			if (eat_timer <= 0)
			{
				target.kill();
				eating = false;
				eat_timer = 240;
			}
			else
				eat_timer--;
		}
		
		super.update(elapsed);
	}
	
	function feast(_p:Passenger, _t:Grunt)
	{
		if (!_p.is_dead && !FlxG.overlap(_t, PlayState.i.enemies))
		{
			FlxG.sound.play("assets/sounds/yell.wav");
			velocity.set();
			hunger = 180;
			_t.eating = true;
			_t.x = _p.x - 8;
			facing = FlxObject.RIGHT;
			target = _p;
		}
	}
	
	function animations()
	{
		if (eating)
			animation.play("eat");
		else if (!isTouching(FlxObject.FLOOR))
		{
			if (velocity.y > 0)
				animation.play("fall");
			else
				animation.play("jump");
		}
		else
		{
			if (velocity.x == 0)
				animation.play("eat");
			else
				animation.play("run");
		}
	}
	
	function calculate_direction()
	{
		facing = getMidpoint().x > get_player_pos().x ? FlxObject.LEFT : FlxObject.RIGHT;
	}
	
	function flip_direction()
	{
		facing = facing == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT;
		x += facing == FlxObject.LEFT ? -5 : 5;
	}
	
	var shoot_timer:Int = 60;
	var round:Int = 0;
	
	function chase_player()
	{
		hunger = 180;
		if (Math.random() > 0.95)
			calculate_direction();
		//shoot
		if (shoot_timer == 0)
		{
			round++;
			if (round % 4 != 0 && round % 5 != 0)
			{
				shoot();
			}
			shoot_timer = 30;
		}
		else 
			shoot_timer--;
	}
	
	function shoot()
	{
		FlxG.sound.play("assets/sounds/shoot2.wav");
		var _a = facing == FlxObject.LEFT ? 180 : 0;
		var _v = ZMath.velocityFromAngle(_a + ZMath.randomRange( -2, 2), 200);
		var _o = facing == FlxObject.LEFT ? -6 : 6;
		var _p = FlxPoint.get(getMidpoint().x + _o, getMidpoint().y);
		PlayState.i.enemy_bullets.fire(_p, _v);
		PlayState.i.explosions.fire(FlxPoint.get(_p.x + _o * 2, _p.y), 0.5);
	}
	
	function jump()
	{
		velocity.y -= 350;
	}
	
	function get_player_pos():FlxPoint
	{
		return PlayState.i.conductor.getMidpoint();
	}
	
	override public function kill():Void 
	{
		PlayState.i.gibs.fire(getMidpoint());
		eating = false;
		super.kill();
		FlxG.sound.play("assets/sounds/die2.wav");
	}
	
}