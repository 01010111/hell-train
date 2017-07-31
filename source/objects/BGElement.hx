package objects;
import flixel.addons.display.FlxBackdrop;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ...
 */
class BGElement extends FlxBackdrop
{
	
	var _bv:Float;
	
	public function new(_z:Int, _g:FlxGraphicAsset) 
	{
		super(_g, _z / 100, 1, true, false);
		_bv = -_z * 5;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		velocity.x = _bv * (PlayState.i.train_speed * 0.01);
	}
	
	
	
}