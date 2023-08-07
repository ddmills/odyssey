package screens.loading;

import core.Screen;
import core.input.KeyCode;
import domain.World;
import screens.adventure.AdventureScreen;

class LoadingScreen extends Screen
{
	public function new() {}

	public override function onEnter()
	{
		game.mount();
	}

	override function onKeyDown(key:KeyCode)
	{
		if (key == KEY_N)
		{
			var seed = Std.random(0xffffff);
			trace('seed - ${seed}');
			game.files.deleteSave('test');
			game.files.setSaveName('test');
			game.setWorld(new World());
			game.world.initialize();
			game.world.newGame(seed);
			start();
		}
		if (key == KEY_L)
		{
			game.files.setSaveName('test');
			var data = game.files.tryReadWorld();
			game.setWorld(new World());
			game.world.initialize();
			game.world.load(data);
			start();
		}
	}

	private function start()
	{
		game.screens.set(new AdventureScreen());
	}
}
