package screens.play;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import domain.components.Blocker;
import domain.components.Energy;
import domain.components.Move;
import domain.components.MoveComplete;
import domain.components.Sprite;
import screens.console.ConsoleScreen;
import screens.cursor.CursorScreen;

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

		world.player.entity.x = 16;
		world.player.entity.y = 16;

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
			var cmd = game.commands.peek();
			if (cmd != null)
			{
				if (world.player.entity.has(Move))
				{
					world.systems.movement.finishMoveFast(world.player.entity);
				}
				else
				{
					handle(game.commands.next());
				}
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
			case CMD_LOOK:
				game.screens.push(new CursorScreen());
			case _:
		}

		return true;
	}

	private function move(x:Int, y:Int)
	{
		var target = world.player.pos.ciel().add(new Coordinate(x, y, WORLD));

		var entities = world.getEntitiesAt(target);
		if (entities.exists((e) -> e.has(Blocker)))
		{
			return;
		}
		world.player.entity.add(new Move(target, .16, LINEAR));
		world.player.entity.get(Energy).consumeEnergy(50);
		world.player.entity.get(Sprite).background = null;
	}

	private function renderClock()
	{
		clockText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		clockText.setScale(1);
		clockText.text = world.clock.toString();
		clockText.color = 0xf5f5f5.toHxdColor();
		clockText.x = 16;
		clockText.y = 16;
		game.render(HUD, clockText);
	}
}
