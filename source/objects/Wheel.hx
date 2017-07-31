package objects;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class Wheel extends FlxSprite
{

	public function new(_p:FlxPoint) 
	{
		super(_p.x, _p.y, "assets/images/wheel.png");
		angle += ZMath.randomRange(0, 360);
	}
	
	override public function update(elapsed:Float):Void 
	{
		angle += PlayState.i.train_speed * 0.25;
		super.update(elapsed);
	}
	
}