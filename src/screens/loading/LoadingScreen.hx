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
		game.camera.zoom = 1;
		world.player.entity.x = 100;
		world.player.entity.y = 100;
		game.screens.set(new AdventureScreen());
	}
}
