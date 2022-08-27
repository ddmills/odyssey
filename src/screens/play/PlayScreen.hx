package screens.play;

import core.Frame;
import core.Screen;
import data.TileResources;
import domain.components.Glyph;
import ecs.Entity;

class PlayScreen extends Screen
{
	public function new() {}

	public override function onEnter()
	{
		var player = new Entity();
		player.add(new Glyph(TileResources.HUMAN, '@'));
		player.x = 5;
		player.y = 3;
		game.camera.x = -32;
		game.camera.y = -64;
	}

	public override function update(frame:Frame)
	{
		world.updateSystems();
	}
}
