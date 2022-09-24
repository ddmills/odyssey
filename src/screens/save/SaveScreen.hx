package screens.save;

import core.Screen;
import screens.loading.LoadingScreen;

class SaveScreen extends Screen
{
	var teardown:Bool;

	public function new(teardown:Bool = false)
	{
		this.teardown = teardown;
	}

	public override function onEnter()
	{
		if (teardown)
		{
			var data = world.save(true);
			game.files.saveWorld(data);
			game.setWorld(null);
			game.screens.replace(new LoadingScreen());
		}
		else
		{
			var data = world.save(false);
			game.files.saveWorld(data);
			game.screens.pop();
		}
	}
}
