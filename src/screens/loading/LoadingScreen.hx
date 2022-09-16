package screens.loading;

import core.Screen;
import screens.adventure.AdventureScreen;

class LoadingScreen extends Screen
{
	public function new() {}

	public override function onEnter()
	{
		game.mount();
		game.world.initialize();
		game.camera.zoom = 2;

		// swamp
		// world.player.entity.x = 149;
		// world.player.entity.y = 161;
		// forest
		world.player.entity.x = 64;
		world.player.entity.y = 64;
		game.screens.set(new AdventureScreen());
	}
}
