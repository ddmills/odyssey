package screens.play;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import data.Cardinal;
import domain.components.Blocker;
import domain.components.Energy;
import domain.components.Move;
import domain.components.MoveComplete;
import domain.components.Sprite;
import screens.console.ConsoleScreen;
import screens.cursor.CursorScreen;
import screens.interaction.InteractionScreen;

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
		clockText.text = world.clock.toString() + ' ' + world.player.pos.floor().toString();

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

	function handle(command:Command):Bool
	{
		switch (command.type)
		{
			case CMD_MOVE_NW:
				move(NORTH_WEST);
			case CMD_MOVE_N:
				move(NORTH);
			case CMD_MOVE_NE:
				move(NORTH_EAST);
			case CMD_MOVE_E:
				move(EAST);
			case CMD_MOVE_W:
				move(WEST);
			case CMD_MOVE_SW:
				move(SOUTH_WEST);
			case CMD_MOVE_S:
				move(SOUTH);
			case CMD_MOVE_SE:
				move(SOUTH_EAST);
			case CMD_WAIT:
				world.player.entity.get(Energy).consumeEnergy(50);
			case CMD_CONSOLE:
				game.screens.push(new ConsoleScreen());
			case CMD_LOOK:
				game.screens.push(new CursorScreen());
			case CMD_INTERACT:
				onInteract(world.player.pos);
			case _:
		}

		return true;
	}

	private function move(dir:Cardinal)
	{
		var target = world.player.pos.toIntPoint().add(dir.toOffset());
		var entities = world.getEntitiesAt(target);
		if (entities.exists((e) -> e.has(Blocker)))
		{
			return;
		}
		world.player.entity.add(new Move(target.asWorld(), .16, LINEAR));
		world.player.entity.get(Energy).consumeEnergy(50);
		world.player.entity.get(Sprite).background = null;
	}

	private function onInteract(pos:Coordinate)
	{
		game.screens.push(new InteractionScreen(world.player.entity));
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
