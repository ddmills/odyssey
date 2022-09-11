package screens.death;

import core.Frame;
import core.Screen;
import data.TextResources;
import h2d.Text;

class DeathScreen extends Screen
{
	public var text:Text;

	public function new()
	{
		text = new Text(TextResources.BIZCAT);
		text.color = 0xf5f5f5.toHxdColor();
		text.text = 'You died. Game over';
		text.textAlign = Center;
		text.y = 32;
	}

	public override function onEnter()
	{
		game.render(HUD, text);
	}

	public override function onDestroy()
	{
		text.remove();
	}

	public override function update(frame:Frame)
	{
		text.x = game.window.width / 2;
		game.camera.focus = world.player.pos;
		world.updateSystems();
	}
}
