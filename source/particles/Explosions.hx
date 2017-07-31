package particles;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class Explosions extends FlxTypedGroup<Explosion>
{

	public function new() 
	{
		super();
		for (i in 0...64)
			add(new Explosion());
	}
	
	public function fire(_p:FlxPoint, _s:Float = 1)
	{
		if (getFirstAvailable() != null)
			getFirstAvailable().fire(_p, _s);
	}
	
}

class Explosion extends FlxSprite
{
	
	public function new()
	{
		super();
		loadGraphic("assets/images/explosion.png", true, 64, 64);
		animation.add('play', [0, 1, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9], 30, false);
		setSize(0, 0);
		offset.set(32, 32);
	}
	
	public function fire(_p:FlxPoint, _s:Float)
	{
		scale.set(_s, _s);
		angle = ZMath.randomRangeInt(0, 3) * 90;
		animation.play('play');
		setPosition(_p.x, _p.y);
		exists = true;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (animation.finished)
			kill();
		super.update(elapsed);
	}
	
}