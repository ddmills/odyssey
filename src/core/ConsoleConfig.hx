package core;

import core.input.Command;
import data.Commands;
import h2d.Console;

class ConsoleConfig
{
	public static function Config(console:Console)
	{
		console.log('Type "help" for list of commands.');

		console.addCommand('exit', 'Close the console', [], () ->
		{
			Game.instance.screens.pop();
		});

		console.addCommand('cmds', 'List available commands on current screen', [], () ->
		{
			console.log('Available commands', 0xffff00);
			Commands.GetForDomain(Game.instance.screens.previous.inputDomain).each((cmd:Command) ->
			{
				console.log('${cmd.friendlyKey()} - ${cmd.name}', 0xffff00);
			});
		});

		console.addAlias('quit', 'exit');
		console.addAlias('q', 'exit');

		console.addCommand('ecount', 'Entity Count', [], () -> entityCountCmd(console));
	}

	static function entityCountCmd(console:Console)
	{
		console.log('Entities: ${Game.instance.registry.size}', 0xffff00);
	}
}
