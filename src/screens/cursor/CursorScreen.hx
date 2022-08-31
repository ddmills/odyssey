package screens.cursor;

import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Frame;
import core.Screen;
import screens.console.ConsoleScreen;
import screens.cursor.renderer.CursorRenderer;
import screens.cursor.renderer.LookCursorRenderer;

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
	public var renderer:CursorRenderer;

	public function new()
	{
		inputDomain = INPUT_DOMAIN_DEFAULT;
		start = world.player.pos.floor();
		target = world.player.pos.floor();
		renderer = new LookCursorRenderer();
	}

	public override function update(frame:Frame)
	{
		renderer.render({
			start: start,
			end: target,
			line: new Array<IntPoint>(),
		});
		renderer.update(frame);
		world.updateSystems();
		handleInput();
	}

	public override function onDestroy()
	{
		renderer.cleanup();
	}

	private function look(dx:Int, dy:Int)
	{
		target = target.add(new Coordinate(dx, dy, WORLD));
	}

	private function handleInput()
	{
		var command = game.commands.next();

		if (command == null)
		{
			return;
		}

		switch (command.type)
		{
			case CMD_MOVE_NW:
				look(-1, -1);
			case CMD_MOVE_N:
				look(0, -1);
			case CMD_MOVE_NE:
				look(1, -1);
			case CMD_MOVE_E:
				look(1, 0);
			case CMD_MOVE_W:
				look(-1, 0);
			case CMD_MOVE_SW:
				look(-1, 1);
			case CMD_MOVE_S:
				look(0, 1);
			case CMD_MOVE_SE:
				look(1, 1);
			case CMD_CANCEL:
				game.screens.pop();
			case CMD_CONSOLE:
				game.screens.push(new ConsoleScreen());
			case _:
		}
	}
}
