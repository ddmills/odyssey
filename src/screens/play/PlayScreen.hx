package screens.play;

import core.Frame;
import core.Screen;

class PlayScreen extends Screen
{
	public function new() {}

	public override function onEnter() {}

	public override function update(frame:Frame)
	{
		world.updateSystems();
	}
}
