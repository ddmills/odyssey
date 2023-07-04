package screens.cursor;

import common.algorithm.Bresenham;
import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Frame;
import core.Screen;
import core.input.Command;
import data.Cardinal;
import screens.console.ConsoleScreen;

typedef CursorRenderOpts =
{
	var start:Coordinate;
	var end:Coordinate;
	var line:Array<IntPoint>;
}

class CursorScreen extends Screen
{
	public var start:Coordinate;
	public var target:Coordinate;

	public function new()
	{
		inputDomain = INPUT_DOMAIN_DEFAULT;
		start = world.player.pos.floor();
		target = world.player.pos.floor();
	}

	public override function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		target = pos.toWorld().floor();
	}

	private function look(dir:Cardinal)
	{
		target = target.add(dir.toOffset().asWorld());
	}

	function render(opts:CursorRenderOpts) {}

	private function handleInput(command:Command)
	{
		switch (command.type)
		{
			case CMD_MOVE_NW:
				look(NORTH_WEST);
			case CMD_MOVE_N:
				look(NORTH);
			case CMD_MOVE_NE:
				look(NORTH_EAST);
			case CMD_MOVE_E:
				look(EAST);
			case CMD_MOVE_W:
				look(WEST);
			case CMD_MOVE_SW:
				look(SOUTH_WEST);
			case CMD_MOVE_S:
				look(SOUTH);
			case CMD_MOVE_SE:
				look(SOUTH_EAST);
			case CMD_LOOK:
				game.screens.pop();
			case CMD_CANCEL:
				game.screens.pop();
			case CMD_CONSOLE:
				game.screens.push(new ConsoleScreen());
			case _:
		}
	}
}
