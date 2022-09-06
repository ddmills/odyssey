package core.input;

import common.struct.Queue;
import data.Commands;

class CommandManager
{
	public var game(get, null):Game;

	private var queue:Queue<Command>;

	inline function get_game():Game
	{
		return Game.instance;
	}

	public function new()
	{
		queue = new Queue();
	}

	public function hasNext():Bool
	{
		return peek() != null;
	}

	public function peek():Null<Command>
	{
		if (queue.length > 0)
		{
			return queue.peek();
		}

		var commands = Commands.GetForDomains([game.screens.domain, INPUT_DOMAIN_DEFAULT]);

		while (game.input.hasNext())
		{
			var event = game.input.peek();
			var input = commands.find((c) -> c.isMatch(event));

			if (input != null)
			{
				return input;
			}
			else
			{
				game.input.next();
			}
		}

		return null;
	}

	public function next():Null<Command>
	{
		if (queue.length > 0)
		{
			return queue.dequeue();
		}

		var commands = Commands.GetForDomains([game.screens.domain, INPUT_DOMAIN_DEFAULT]);

		while (game.input.hasNext())
		{
			var event = game.input.next();
			var input = commands.find((c) -> c.isMatch(event));

			if (input != null)
			{
				return input;
			}
		}

		return null;
	}

	public function push(command:Command)
	{
		queue.enqueue(command);
	}
}
