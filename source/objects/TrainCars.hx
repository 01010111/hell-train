package objects;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author ...
 */
class TrainCars extends FlxSpriteGroup
{
	
	var engine:FlxSprite;
	var car1:FlxSprite;
	var car2:FlxSprite;
	var car3:FlxSprite;
	var car4:FlxSprite;
	var caboose_a:FlxSprite;
	var caboose_b:FlxSprite;
	
	public function new() 
	{
		super();
		
		engine = new FlxSprite(1639, 112, "assets/images/engine.png");
		car1 = new FlxSprite(1317, 80, "assets/images/car1.png");
		car2 = new FlxSprite(997, 48, "assets/images/car2.png");
		car3 = new FlxSprite(677, 32, "assets/images/car3.png");
		car4 = new FlxSprite(357, 96, "assets/images/car4.png");
		caboose_a = new FlxSprite(116, 48, "assets/images/caboose_a.png");
		caboose_b = new FlxSprite(69, 96, "assets/images/caboose_b.png");
		
		add(engine);
		add(car1);
		add(car2);
		add(car3);
		add(car4);
		add(caboose_a);
		add(caboose_b);
	}
	
}