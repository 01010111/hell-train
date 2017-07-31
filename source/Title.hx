package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

/**
 * ...
 * @author ...
 */
class Title extends FlxState
{

	override public function create():Void 
	{
		add(new FlxSprite(0, 0, "assets/images/title.png"));
		super.create();
		FlxG.mouse.visible = false;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (FlxG.keys.justPressed.C)
		{
			FlxG.sound.play("assets/sounds/yes.wav");
			FlxG.switchState(new PlayState());
		}
		super.update(elapsed);
	}
	
}