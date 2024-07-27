import core.Game;
import data.AnimationResources;
import data.AudioResources;
import data.BiomeMap;
import data.Bitmasks;
import data.Commands;
import data.Factions;
import data.TextResources;
import data.TileResources;
import data.core.ColorPaletteResources;
import data.dialog.DialogTrees;
import data.storylines.Stories;
import data.tables.SpawnTables;
import domain.data.liquids.Liquids;
import domain.skills.Skills;
import domain.stats.Stats;
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

		s2d.renderer.globals.set("dayProgress", 0);
		s2d.renderer.globals.set("screenH", 800);

		var window = hxd.Window.getInstance();

		window.addResizeEvent(() ->
		{
			trace('resize', window.height);
			s2d.renderer.globals.set("screenH", window.height);
		});

		TextResources.Init();
		TileResources.Init();
		ColorPaletteResources.Init();
		AnimationResources.Init();
		AudioResources.Init();
		Bitmasks.Init();
		SpawnTables.Init();
		Commands.Init();
		Stats.Init();
		Skills.Init();
		Weapons.Init();
		Liquids.Init();
		BiomeMap.Init();
		PoiLayouts.Init();
		RoomDecorators.Init();
		Stories.Init();
		DialogTrees.Init();
		Factions.Init();

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
