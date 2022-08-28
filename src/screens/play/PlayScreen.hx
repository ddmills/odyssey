package screens.play;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import data.KeyCode;
import data.Keybinding;
import data.TextResources;
import domain.components.Move;

class PlayScreen extends Screen
{
	var clockText:h2d.Text;

	public function new() {}

	public override function onEnter()
	{
		game.camera.zoom = 2;

		var target = world.player.pos.add(new Coordinate(1, 1, WORLD));

		world.player.entity.add(new Move(target, .16, LINEAR));

		renderClock();
	}

	public override function update(frame:Frame)
	{
		world.updateSystems();
		game.camera.focus = world.player.pos;
		clockText.text = world.clock.toString();
	}

	public override function onKeyUp(key:KeyCode)
	{
		switch key
		{
			case MOVE_NW:
				move(-1, -1);
			case MOVE_N:
				move(0, -1);
			case MOVE_NE:
				move(1, -1);
			case MOVE_E:
				move(1, 0);
			case MOVE_W:
				move(-1, 0);
			case MOVE_SW:
				move(-1, 1);
			case MOVE_S:
				move(0, 1);
			case MOVE_SE:
				move(1, 1);
			case _:
		}
	}

	private function move(x:Int, y:Int)
	{
		var target = world.player.pos.ciel().add(new Coordinate(x, y, WORLD));

		world.player.entity.add(new Move(target, .16, LINEAR));
	}

	private function renderClock()
	{
		clockText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		clockText.setScale(1);
		clockText.text = world.clock.toString();
		clockText.color = new h3d.Vector(1, 1, .9);
		clockText.x = 16;
		clockText.y = 16;
		game.render(HUD, clockText);
	}
}
