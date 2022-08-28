package screens.play;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import data.KeyCode;
import data.Keybinding;
import domain.components.Move;

class PlayScreen extends Screen
{
	public function new() {}

	public override function onEnter()
	{
		game.camera.zoom = 2;

		var target = world.player.pos.add(new Coordinate(1, 1, WORLD));

		world.player.entity.add(new Move(target, .16, LINEAR));
	}

	public override function update(frame:Frame)
	{
		world.updateSystems();
		game.camera.focus = world.player.pos;
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
		var target = world.player.pos.add(new Coordinate(x, y, WORLD));

		world.player.entity.add(new Move(target, .16, LINEAR));
	}
}
