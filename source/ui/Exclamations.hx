package ui;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class Exclamations extends FlxSpriteGroup
{

	public function new() 
	{
		super();
		add(new Exclamation(true));
		add(new Exclamation(false));
		scrollFactor.set();
	}
	
}

class Exclamation extends FlxSprite
{
	var l:Bool;
	
	public function new(_l:Bool)
	{
		l = _l;
		var _x = _l ? 8 : FlxG.width - 72;
		super(_x, 64);
		loadGraphic("assets/images/exclamation.png", true, 64, 64);
		animation.add('play', [0], 1, true, !l);
		animation.play('play');
		scale.set();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		var d = 9999.0;
		
		for (e in PlayState.i.enemies)
		{
			if (!e.isOnScreen() && e.eating && (l && e.x < PlayState.i.conductor.x || !l && PlayState.i.conductor.x < e.x))
			{
				var nd = Math.abs(e.x - PlayState.i.conductor.x);
				if (nd < d)
					d = nd;
			}
		}
		
		var _s = d == 9999 ? 0 : ZMath.map(d, 0, 400, 2, 1);
		var _y = ZMath.map(d, 0, 400, FlxG.height * 0.4, 0);
		_s = ZMath.clamp(_s, 0.5, 1.5);
		_y = ZMath.clamp(_y, 64, FlxG.height * 0.4);
		
		scale.x += (_s - scale.x) * 0.2;
		scale.y += (_s - scale.y) * 0.2;
		//scale.x *= l ? 1 : -1;
		y += (_y - y) * 0.2;
		
		visible = d < 9999;
		
		if (Math.random() > 0.75)
			offset.x = ZMath.randomRangeInt( -1, 1);
		if (Math.random() > 0.75)
			offset.y = ZMath.randomRangeInt( -1, 1);
	}
	
}