package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import objects.BGElement;
import objects.Conductor;
import objects.EnemySpawner;
import objects.Gibs;
import objects.Passenger;
import objects.TrainCars;
import objects.Wheel;
import openfl.display.BlendMode;
import particles.EnemyBullets;
import particles.Explosions;
import particles.PlayerBullets;
import ui.Bullets;
import ui.Exclamations;
import ui.Life;
import ui.TrainSpeed;
import zerolib.ZMath;

class PlayState extends FlxState
{
	public static var i:PlayState;
	
	public var train:FlxTilemap;
	public var conductor:Conductor;
	public var train_cars:TrainCars;
	public var train_speed:Float = 100;
	public var bg_elements:FlxGroup;
	public var fg_elements:FlxGroup;
	public var player_bullets:PlayerBullets;
	public var enemy_bullets:EnemyBullets;
	public var explosions:Explosions;
	public var enemies:EnemySpawner;
	public var vips:FlxTypedGroup<Passenger>;
	public var bullet_ui:Bullets;
	public var gibs:Gibs;
	public var coal:Gibs;
	public var distance:Float = 0;
	
	public var locomotion:Float = 0;
	
	override public function create():Void
	{
		init_stage();
		init_groups();
		init_objects();
		add_objects_to_stage();
		init_camera();
	}
	
	function init_stage()
	{
		
		FlxG.sound.playMusic("assets/music/untitled.wav", 0.1);
		FlxG.watch.add(this, "distance", "D:");
		bgColor = 0xfffff024;
		i = this;
		super.create();
		new FlxTimer().start(1, remove_locomotion, 0);
	}
	
	function remove_locomotion(?t:FlxTimer)
	{
		locomotion -= 0.2;
	}
	
	function init_groups()
	{
		bg_elements = new FlxGroup();
		fg_elements = new FlxGroup();
		player_bullets = new PlayerBullets(6);
		enemy_bullets = new EnemyBullets(32);
		explosions = new Explosions();
		enemies = new EnemySpawner();
		vips = new FlxTypedGroup();
		bullet_ui = new Bullets();
		gibs = new Gibs();
		coal = new Gibs(true);
	}
	
	function init_objects()
	{
		conductor = new Conductor();
		add_vips();
		
		for (i in 0...8)
		{
			coal.fire(FlxPoint.get(1600 - FlxG.width + 64 + i * ZMath.randomRange(8, 16), FlxG.height * 0.5));
		}
		
		var o = new FlxOgmoLoader("assets/data/level.oel");
		train = o.loadTilemap("assets/images/tiles.png", 16, 16, 'Tiles');
		var cloud_tiles = [7, 8, 9];
		var pass_tiles = [0, 12, 13, 14, 15];
		for (n in cloud_tiles)
			train.setTileProperties(n, FlxObject.CEILING);
		for (n in pass_tiles)
			train.setTileProperties(n, FlxObject.NONE);
		
		create_background();
		
		train_cars = new TrainCars();
	}
	
	function add_vips()
	{
		for (i in 1...4)
		{
			for (n in 0...3)
			{
				vips.add(new Passenger(FlxPoint.get(96 + n * 24 + i * FlxG.width, 138)));
				vips.add(new Passenger(FlxPoint.get(188 + n * 24 + i * FlxG.width, 138)));
			}
		}
	}
	
	function create_background()
	{
		var backdrop_index = [5, 10, 25, 50, 400];
		for (n in backdrop_index)
		{
			var b = new BGElement(n, "assets/images/z" + n + ".png");
			n > 100 ? fg_elements.add(b) : bg_elements.add(b);
		}
	}
	
	function add_objects_to_stage()
	{
		add(bg_elements);
		add(train_cars);
		add(vips);
		add(player_bullets);
		add(enemy_bullets);
		add(train);
		add(enemies);
		var s = new FlxSprite(0, FlxG.height - 56);
		s.makeGraphic(FlxG.width, 56, 0xff000000);
		s.scrollFactor.set();
		add(s);
		add_wheels();
		add(gibs);
		add(coal);
		add(conductor);
		add(explosions);
		add(fg_elements);
		add(bullet_ui);
		add(new Exclamations());
		add(new Life());
		add(new TrainSpeed());
	}
	
	function add_wheels()
	{
		for (i in 0...6)
		{
			add(new Wheel(FlxPoint.get(i * FlxG.width + 36, 168)));
			add(new Wheel(FlxPoint.get(i * FlxG.width + 68, 168)));
			add(new Wheel(FlxPoint.get(i * FlxG.width + 228, 168)));
			add(new Wheel(FlxPoint.get(i * FlxG.width + 260, 168)));
		}
	}
	
	function init_camera():Void
	{
		var cam_up = 0;
		FlxG.camera.follow(conductor);
		//FlxG.camera.follow(conductor, FlxCameraFollowStyle.SCREEN_BY_SCREEN, 0.05);
		FlxG.camera.setScrollBoundsRect(0, -cam_up, train.width, FlxG.height + cam_up, true);
	}

	override public function update(elapsed:Float):Void
	{
		if (locomotion > 8)
			locomotion = 8;
		super.update(elapsed);
		FlxG.collide(train, conductor);
		FlxG.collide(train, enemies);
		FlxG.collide(train, gibs);
		FlxG.collide(train, coal);
		FlxG.collide(train, player_bullets, kill_bullet);
		FlxG.collide(train, enemy_bullets, kill_bullet);
		FlxG.overlap(enemies, player_bullets, kill_enemy);
		FlxG.overlap(conductor, enemy_bullets, kill_enemy);
		
		train_speed += locomotion * 0.05;
		train_speed = ZMath.clamp(train_speed, 0, 9999);
		
		distance += train_speed * 0.0001;
		
		if (FlxG.keys.justPressed.R)
			FlxG.switchState(new PlayState());
	}
	
	function kill_bullet(_o:FlxObject, _b:FlxSprite)
	{
		_b.kill();
		FlxG.sound.play("assets/sounds/explode.wav");
	}
	
	function kill_enemy(_e:FlxSprite, _b:FlxSprite)
	{
		_b.kill();
		blood_splatter(_e);
		_e.kill();
		FlxG.sound.play("assets/sounds/explode.wav");
	}
	
	public function blood_splatter(_o:FlxObject, _amt:Int = 32)
	{
		for (s in train_cars)
		{
			if (FlxG.overlap(_o, s))
			{
				for (i in 0...Std.int(_amt * 0.5))
				{
					var _p = ZMath.placeOnCircle(FlxPoint.get(_o.x - s.x, _o.y - s.y), ZMath.randomRange(0, 360), ZMath.randomRange(0, 32));
					FlxSpriteUtil.drawCircle(s, _p.x, _p.y, ZMath.randomRange(1, 3), 0xffff004d);
				}
				for (i in 0...Std.int(_amt * 0.5))
				{
					var _p = ZMath.placeOnCircle(FlxPoint.get(_o.x - s.x, _o.y - s.y), ZMath.randomRange(0, 360), ZMath.randomRange(0, 8));
					var _s = ZMath.randomRangeInt(1, 5);
					var blood = new FlxSprite();
					blood.makeGraphic(_s, _s, 0x00ffffff);
					FlxSpriteUtil.drawCircle(blood, -1, -1, 0, 0xffae0028);
					//blood.blend = BlendMode.OVERLAY;
					blood.scale.y = 2;
					//FlxSpriteUtil.drawCircle(s, _p.x, _p.y, ZMath.randomRange(1, 5), 0xffff004d);
					s.stamp(blood, Std.int(_p.x), Std.int(_p.y));
				}
			}
		}
	}
	
}
