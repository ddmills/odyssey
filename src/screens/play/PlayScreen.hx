package screens.play;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import core.input.KeyCode;
import domain.components.Energy;
import domain.components.Move;
import domain.components.MoveComplete;
import domain.components.Sprite;
import screens.console.ConsoleScreen;

class PlayScreen extends Screen
{
	var clockText:h2d.Text;

	public function new()
	{
		inputDomain = INPUT_DOMAIN_ADVENTURE;
	}

	public override function onEnter()
	{
		game.camera.zoom = 2;

		world.player.entity.x = 6;
		world.player.entity.y = 6;

		renderClock();
	}

	public override function update(frame:Frame)
	{
		world.updateSystems();
		game.camera.focus = world.player.pos;
		clockText.text = world.clock.toString();

		if (world.player.entity.has(MoveComplete))
		{
			world.player.entity.get(Sprite).background = game.CLEAR_COLOR;
		}

		if (world.systems.energy.isPlayersTurn)
		{
			var cmd = game.commands.next();
			if (cmd != null)
			{
				world.systems.movement.finishMoveFast(world.player.entity);

				handle(cmd);
			}
		}
	}

	public override function onKeyDown(key:KeyCode)
	{
		if (key == KEY_TAB)
		{
			var cmd = game.commands.next();
			if (cmd != null)
			{
				trace(cmd.toString());
			}
		}
	}

	public function handle(command:Command):Bool
	{
		switch (command.type)
		{
			case CMD_MOVE_NW:
				move(-1, -1);
			case CMD_MOVE_N:
				move(0, -1);
			case CMD_MOVE_NE:
				move(1, -1);
			case CMD_MOVE_E:
				move(1, 0);
			case CMD_MOVE_W:
				move(-1, 0);
			case CMD_MOVE_SW:
				move(-1, 1);
			case CMD_MOVE_S:
				move(0, 1);
			case CMD_MOVE_SE:
				move(1, 1);
			case CMD_WAIT:
				world.player.entity.get(Energy).consumeEnergy(50);
			case CMD_CONSOLE:
				game.screens.push(new ConsoleScreen());
			case _:
		}

		return true;
	}

	private function move(x:Int, y:Int)
	{
		var target = world.player.pos.ciel().add(new Coordinate(x, y, WORLD));

		world.player.entity.add(new Move(target, .16, LINEAR));
		world.player.entity.get(Energy).consumeEnergy(50);
		world.player.entity.get(Sprite).background = null;
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
