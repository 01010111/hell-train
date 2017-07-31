package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class GameOver extends FlxState
{
	
	var dist:Int;
	var dolly:FlxObject;
	var p:FlxPoint;
	var a:Float = -45;
	var la:Float = -45;
	var da:Float = 0;
	var real_dist:Int;
	
	var tracks:Trax;
	
	public function new(_d:Float) 
	{
		super();
		//FlxG.log.warn(_d);
		dist = Std.int(_d / 5);
		real_dist = Std.int(_d);
		//FlxG.log.warn(dist);
	}
	
	override public function create():Void 
	{
		bgColor = 0xff000000;
		dolly = new FlxObject(FlxG.width * 0.5, FlxG.height * 0.5, 2, 2);
		add(dolly);
		p = FlxPoint.get(FlxG.width * 0.5, FlxG.height * 0.5);
		tracks = new Trax();
		add(tracks);
		make_trax();
		FlxG.camera.follow(dolly);
	}
	
	function make_trax(?t:FlxTimer)
	{
		dist -= 1;
		tracks.fire(p, a);
		var _p = ZMath.velocityFromAngle(a, 5);
		p.set(p.x + _p.x, p.y + _p.y);
		a += da;
		da += ZMath.randomRange( -1, 1);
		da = ZMath.clamp(da, -5, 5);
		if (dist > 0)
			new FlxTimer().start(0.05, make_trax);
		else
			end();
	}
	
	override public function update(elapsed:Float):Void 
	{
		dolly.x += (p.x - dolly.x) * 0.1;
		dolly.y += (p.y - dolly.y) * 0.1;
		super.update(elapsed);
		if (FlxG.keys.justPressed.C)
		{
			FlxG.sound.play("assets/sounds/yes.wav");
			FlxG.switchState(new PlayState());
		}
	}
	
	function end()
	{
		//FlxG.log.warn(dist);
		//FlxG.switchState(new PlayState());
		var t = new FlxText(p.x, p.y - 16, FlxG.width, "YOU TRAVELED " + real_dist + "KM!", 8);
		add(t);
	}
	
}

class Trax extends FlxTypedGroup<Trak>
{
	
	public function new()
	{
		super();
		for (i in 0...128)
			add(new Trak());
	}
	
	public function fire(_p:FlxPoint, _a:Float)
	{
		if (getFirstAvailable() != null)
			getFirstAvailable().fire(_p, _a);
	}
	
}

class Trak extends FlxSprite
{
	
	public function new()
	{
		super();
		exists = false;
		loadGraphic("assets/images/trax.png", true, 2, 10);
		
		var array:Array<Int> = [];
		for (i in 0...7)
		{
			for (n in 0...Std.int(Math.pow(i,2)) + 1)
			{
				array.push(i);
			}
		}
		animation.add("play", array, 48, false);
		scale.y = 2;
	}
	
	public function fire(_p:FlxPoint, _a:Float)
	{
		animation.play("play");
		setPosition(_p.x, _p.y);
		angle = _a;
		exists = true;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (animation.finished)
			kill();
		super.update(elapsed);
	}
	
}