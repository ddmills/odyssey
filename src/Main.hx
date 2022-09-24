import core.Game;
import data.AudioResources;
import data.Commands;
import data.TextResources;
import data.TileResources;
import domain.data.liquids.Liquids;
import domain.skills.Skills;
import domain.weapons.Weapons;
import screens.loading.LoadingScreen;
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
		Commands.Init();
		Skills.Init();
		Weapons.Init();
		Liquids.Init();

		hxd.Window.getInstance().title = "Odyssey";

		game = Game.Create(this);
		game.backgroundColor = game.CLEAR_COLOR;
		game.screens.set(new LoadingScreen());
	}

	override function update(dt:Float)
	{
		game.update();
	}
}
