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

		world.player.entity.x = 26;
		world.player.entity.y = 37;
		game.screens.set(new AdventureScreen());
	}
}
