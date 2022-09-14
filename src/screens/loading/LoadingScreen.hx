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

		world.player.entity.x = 16;
		world.player.entity.y = 16;
		game.screens.set(new AdventureScreen());
	}
}
