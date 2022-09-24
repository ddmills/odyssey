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

		// game.world = new World();

		// game.world.initialize();
		// game.camera.zoom = 2;

		// world.player.entity.x = 100;
		// world.player.entity.y = 100;
		// game.screens.set(new AdventureScreen());
	}

	override function onKeyDown(key:KeyCode)
	{
		if (key == KEY_N)
		{
			game.files.setSaveName('test');
			game.setWorld(new World());
			game.world.initialize();
			game.world.newGame(10);
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
		game.camera.zoom = 2;

		game.screens.set(new AdventureScreen());
	}
}
