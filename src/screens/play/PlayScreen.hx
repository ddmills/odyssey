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

		player.add(new Glyph(TileResources.HERO, 0xca8e90, 0x557fb2, '@'));
		player.x = 5;
		player.y = 3;

		game.camera.zoom = 2;
		game.camera.focus = player.pos;
	}

	public override function update(frame:Frame)
	{
		world.updateSystems();
	}
}
