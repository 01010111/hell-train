package objects;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class Passenger extends FlxSprite
{
	
	public var is_dead:Bool = false;
	
	public function new(_p:FlxPoint) 
	{
		super(_p.x, _p.y);
		loadGraphic("assets/images/passenger.png", true, 32, 24);
		animation.add('left', [2, 3], ZMath.randomRangeInt(8, 12));
		animation.add('right', [0, 1], ZMath.randomRangeInt(8, 12));
		animation.add('dead', [ZMath.randomRangeInt(4, 5)]);
		setSize(2, 16);
		offset.set(15, 0);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (is_dead)
			animation.play('dead');
		else
			getMidpoint().x < PlayState.i.conductor.getMidpoint().x ? animation.play('right') : animation.play('left');
		super.update(elapsed);
	}
	
	override public function kill():Void 
	{
		is_dead = true;
		//super.kill();
	}
	
}