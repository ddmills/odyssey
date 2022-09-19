import core.Game;
import data.AudioResources;
import data.Commands;
import data.TextResources;
import data.TileResources;
import domain.skills.Skills;
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

		@:privateAccess this.s2d.renderer.manager.globals.set("tint", 0x0000ff.toHxdColor());

		TextResources.Init();
		TileResources.Init();
		AudioResources.Init();
		Commands.Init();
		Skills.Init();
		Weapons.Init();

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
