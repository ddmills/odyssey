package core;

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

		console.addAlias('quit', 'exit');
		console.addAlias('q', 'exit');

		console.addCommand('hello', 'Print hello', [
			{
				name: 'name',
				opt: false,
				t: AString,
			}
		], (name:String) -> helloCommand(console, name));
	}

	static function helloCommand(console:Console, name:String)
	{
		console.log('Hello ${name}!', 0xffff00);
	}
}
