package particles;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class EnemyBullets extends FlxTypedGroup<EnemyBullet>
{

	public function new(_amt:Int = 16) 
	{
		super();
		for (i in 0..._amt)
			add(new EnemyBullet());
	}
	
	public function fire(_p:FlxPoint, _v:FlxPoint)
	{
		if (getFirstAvailable() != null)
			getFirstAvailable().fire(_p, _v);
	}
	
}

class EnemyBullet extends FlxSprite
{
	
	public function new()
	{
		super();
		loadGraphic("assets/images/enemy_bullet.png", true, 16, 16);
		animation.add("play", [0, 1, 2, 2, 3]);
		setSize(4, 4);
		offset.set(6, 6);
		exists = false;
	}
	
	public function fire(_p:FlxPoint, _v:FlxPoint)
	{
		reset(_p.x - 2, _p.y - 2);
		setPosition(_p.x - 2, _p.y - 2);
		velocity.set(_v.x, _v.y);
		animation.play("play");
		exists = true;
	}
	
	override public function update(elapsed:Float):Void 
	{
		angle = ZMath.angleFromVelocity(velocity.x, velocity.y);
		if (exists)
			if (!isOnScreen())
				kill();
		super.update(elapsed);
	}
	
	override public function kill():Void 
	{
		//explody?
		if (isOnScreen())
			PlayState.i.explosions.fire(getMidpoint());
		super.kill();
	}
	
}