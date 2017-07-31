package objects;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import objects.Gibs.Gib;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class Conductor extends FlxSprite
{
	
	var speed:Float = 200;
	var jump_power:Float = 400;
	public var bodies:Int = 0;
	
	public function new() 
	{
		super(1680, 140);
		loadGraphic("assets/images/conductor.png", true, 48, 24);
		animation.add("idle", [0]);
		animation.add("run", [1, 2, 2, 3, 4, 5, 5, 6], 15);
		animation.add("jump", [5]);
		animation.add("fall", [4]);
		animation.add("dead", [7]);
		acceleration.y = 980;
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setSize(14, 20);
		offset.set(17, 4);
	}
	
	override public function update(elapsed:Float):Void 
	{
		animations();
		if (alive)
			controls();
		super.update(elapsed);
	}
	
	function controls():Void
	{
		var _left = FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A;
		var _right = FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D;
		var _jump = FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.X;
		var _shoot = FlxG.keys.justPressed.SHIFT || FlxG.keys.justPressed.C;
		var _pickup = FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W;
		var _toss = FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S;
		
		var _e = bodies;
		var _s = ZMath.clamp(speed - _e * 10, 10, speed);
		
		if (_jump && isTouching(FlxObject.FLOOR))
			jump(_e);
		
		velocity.x = 0;
		if (_left) 
			velocity.x -= _s;
		if (_right)
			velocity.x += _s;
		
		if (_shoot)
			shoot();
		
		if (_pickup && bodies < 8)
		{
			FlxG.overlap(this, PlayState.i.coal, pick_up_gib);
			FlxG.overlap(this, PlayState.i.gibs, pick_up_gib);
		}
		if (_toss && bodies > 0)
			toss();
	}
	
	function animations():Void
	{
		if (!alive)
			animation.play('dead');
		else if (!isTouching(FlxObject.FLOOR))
		{
			if (velocity.y > 0)
				animation.play('fall');
			else
				animation.play('jump');
		}
		else
		{
			if (velocity.x == 0)
				animation.play('idle');
			else
				animation.play('run');
		}
		
		if (velocity.x > 0)
			facing = FlxObject.RIGHT;
		else if (velocity.x < 0)
			facing = FlxObject.LEFT;
	}
	
	function jump(_encumbrance:Int)
	{
		var pow = ZMath.clamp(jump_power - _encumbrance * 10, 100, 800);
		velocity.y = -pow;
		FlxG.sound.play("assets/sounds/Jump.wav", 0.1);
	}
	
	function shoot()
	{
		FlxG.sound.play("assets/sounds/shoot.wav");
		var _a = facing == FlxObject.LEFT ? 180 : 0;
		var _v = ZMath.velocityFromAngle(_a + ZMath.randomRange( -2, 2), 600);
		var _o = facing == FlxObject.LEFT ? -6 : 6;
		var _p = FlxPoint.get(getMidpoint().x + _o, getMidpoint().y);
		PlayState.i.player_bullets.fire(_p, _v);
		PlayState.i.explosions.fire(FlxPoint.get(_p.x + _o * 2, _p.y), 0.5);
	}
	
	function pick_up_gib(t:Conductor, g:Gib)
	{
		FlxG.sound.play("assets/sounds/pickup.wav");
		if (!g.picked_up)
		{
			g.picked_up = true;
			var p = ZMath.placeOnCircle(FlxPoint.get(), ZMath.randomRange(180, 380), bodies * 2 + 4);
			g.position.set(p.x, p.y);
			bodies++;
		}
	}
	
	function toss()
	{
		for (gib in PlayState.i.gibs)
			if (gib.picked_up)
			{
				var a = facing == FlxObject.LEFT ? 180 + ZMath.randomRange(0, 20) : 0 - ZMath.randomRange(0, 20);
				gib.toss(ZMath.velocityFromAngle(a, 400));
				bodies--;
			}
		for (gib in PlayState.i.coal)
			if (gib.picked_up)
			{
				var a = facing == FlxObject.LEFT ? 180 + ZMath.randomRange(0, 20) : 0 - ZMath.randomRange(0, 20);
				gib.toss(ZMath.velocityFromAngle(a, 400));
				bodies--;
			}
		FlxG.sound.play("assets/sounds/throw.wav");
		organize_gibs();
	}
	
	override public function kill():Void 
	{
		if (bodies <= 0)
		{
			velocity.set();
			alive = false;
			FlxG.camera.fade(0xff000000, 1, false, switch_state);
			FlxG.sound.play("assets/sounds/die.wav");
		}
		else
		{
			for (g in PlayState.i.gibs)
			{
				if (g.picked_up && g.alive)
				{
					g.kill();
					bodies--;
					organize_gibs();
					return;
				}
			}
			for (g in PlayState.i.coal)
			{
				if (g.picked_up && g.alive)
				{
					g.kill();
					bodies--;
					organize_gibs();
					return;
				}
			}
		}
		
		//super.kill();
	}
	
	function switch_state()
	{
		FlxG.switchState(new GameOver(PlayState.i.distance));
	}
	
	function organize_gibs()
	{
		var i = 0;
		for (g in PlayState.i.gibs)
		{
			if (g.picked_up && g.alive)
			{
				var p = ZMath.placeOnCircle(FlxPoint.get(), ZMath.randomRange(180, 380), i * 2 + 4);
				g.position.set(p.x, p.y);
				i++;
			}
		}
		for (g in PlayState.i.coal)
		{
			if (g.picked_up && g.alive)
			{
				var p = ZMath.placeOnCircle(FlxPoint.get(), ZMath.randomRange(180, 380), i * 2 + 4);
				g.position.set(p.x, p.y);
				i++;
			}
		}
	}
	
}