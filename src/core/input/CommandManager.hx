package core.input;

import data.Commands;

class CommandManager
{
	public var game(get, null):Game;

	inline function get_game():Game
	{
		return Game.instance;
	}

	public function new() {}

	public function next():Null<Command>
	{
		var commands = Commands.GetForDomain(game.screens.domain);

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
}
