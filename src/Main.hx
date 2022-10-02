import core.Game;
import data.AudioResources;
import data.BiomeMap;
import data.Bitmasks;
import data.Commands;
import data.TextResources;
import data.TileResources;
import domain.data.liquids.Liquids;
import domain.skills.Skills;
import domain.terrain.gen.pois.PoiLayouts;
import domain.terrain.gen.rooms.RoomDecorators;
import domain.weapons.Weapons;
import screens.splash.SplashScreen;

class Main extends hxd.App
{
	var game:Game;

	static function main()
	{
		hxd.Res.initEmbed();
		new Main();
	}

	override function init()
	{
		// hack to fix audio not playing more than once
		@:privateAccess haxe.MainLoop.add(() -> {});

		@:privateAccess s2d.renderer.manager.globals.set("dayProgress", 0);

		TextResources.Init();
		TileResources.Init();
		AudioResources.Init();
		Bitmasks.Init();
		Commands.Init();
		Skills.Init();
		Weapons.Init();
		Liquids.Init();
		BiomeMap.Init();
		PoiLayouts.Init();
		RoomDecorators.Init();

		hxd.Window.getInstance().title = "Odyssey";

		game = Game.Create(this);
		game.backgroundColor = game.CLEAR_COLOR;
		game.screens.set(new SplashScreen(1));
	}

	override function update(dt:Float)
	{
		game.update();
	}
}
