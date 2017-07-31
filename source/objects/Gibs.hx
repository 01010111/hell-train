package objects;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class Gibs extends FlxTypedGroup<Gib>
{

	public function new(_coal:Bool = false) 
	{
		super();
		for (i in 0...32)
			add(new Gib(_coal));
	}
	
	public function fire(_p:FlxPoint):Gib
	{
		if (getFirstAvailable() != null)
		{
			var g = getFirstAvailable();
			g.fire(_p);
			return g;
		}
		return null;
	}
	
}

class Gib extends FlxSprite
{
	
	public var position:FlxPoint;
	public var picked_up:Bool;
	var coal:Bool;
	
	public function new(_c:Bool)
	{
		super();
		coal = _c;
		position = FlxPoint.get();
		if (_c)
			loadGraphic("assets/images/coal.png", true, 16, 16);
		else
			loadGraphic("assets/images/gibs.png", true, 16, 16);
		animation.frameIndex = ZMath.randomRangeInt(0, 3);
		exists = false;
		alive = false;
		setSize(12, 16);
		offset.set(2);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (picked_up)
		{
			acceleration.y = 0;
			setPosition(position.x + PlayState.i.conductor.x, position.y + PlayState.i.conductor.y);
		}
		else 
		{
			acceleration.y = 980;
		}
		
		if (isTouching(FlxObject.FLOOR))
		{
			velocity.x = 0;
			if (x > 1690)
			{
				FlxG .sound.play("assets/sounds/yes.wav", 0.1);
				add_locomotion();
			}
		}
		
		super.update(elapsed);
	}
	
	public function fire(_p:FlxPoint)
	{
		setPosition(_p.x - 6, _p.y - 8);
		picked_up = false;
		revive();
		var v = ZMath.velocityFromAngle(ZMath.randomRange(180, 360), ZMath.randomRange(50, 100));
		velocity.set(v.x, v.y);
	}
	
	public function toss(_v:FlxPoint)
	{
		picked_up = false;
		velocity.set(_v.x, _v.y);
	}
	
	override public function kill():Void 
	{
		if (!coal)
			PlayState.i.blood_splatter(this, 16);
		super.kill();
	}
	
	function add_locomotion()
	{
		PlayState.i.locomotion++;
		PlayState.i.explosions.fire(getMidpoint());
		kill();
	}
	
}