package screens.loading;

import core.Screen;
import screens.play.PlayScreen;

class LoadingScreen extends Screen
{
	public function new() {}

	public override function onEnter()
	{
		game.mount();
		game.world.initialize();
		game.screens.set(new PlayScreen());
	}
}
