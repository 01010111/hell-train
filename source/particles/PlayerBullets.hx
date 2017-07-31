package particles;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import particles.PlayerBullets.PlayerBullet;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class PlayerBullets extends FlxTypedGroup<PlayerBullet>
{

	public function new(_amt:Int = 16) 
	{
		super();
		for (i in 0..._amt)
			add(new PlayerBullet());
	}
	
	public function fire(_p:FlxPoint, _v:FlxPoint)
	{
		if (getFirstAvailable() != null && PlayState.i.bullet_ui.can_shoot)
			getFirstAvailable().fire(_p, _v);
	}
	
}

class PlayerBullet extends FlxSprite
{
	
	public function new()
	{
		super();
		loadGraphic("assets/images/bullet.png");
		setSize(8, 8);
		offset.set(4, 4);
		exists = false;
	}
	
	public function fire(_p:FlxPoint, _v:FlxPoint)
	{
		PlayState.i.bullet_ui.remove_bullet();
		reset(_p.x - 4, _p.y - 4);
		setPosition(_p.x - 4, _p.y - 4);
		velocity.set(_v.x, _v.y);
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