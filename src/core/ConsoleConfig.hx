package core;

import core.input.Command;
import data.Commands;
import domain.components.Stats;
import domain.skills.Skills;
import h2d.Console;
import haxe.EnumTools;

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
			Commands.GetForDomains([INPUT_DOMAIN_DEFAULT, Game.instance.screens.previous.inputDomain]).each((cmd:Command) ->
			{
				console.log('${cmd.friendlyKey()} - ${cmd.name}', 0xffff00);
			});
		});

		console.addCommand('stats', 'List player stats & skills', [], () ->
		{
			var player = Game.instance.world.player.entity;
			console.log('STATS', 0xffff00);
			Stats.GetAll(player).each((sv) ->
			{
				var name = EnumValueTools.getName(sv.stat) + ' ';
				console.log('${name.pad(31, '.')} ${sv.value}');
			});

			console.log('SKILLS', 0xffff00);
			Skills.GetAll(player).each((sv:SkillValue) ->
			{
				var name = EnumValueTools.getName(sv.skill) + ' ';
				var stat = EnumValueTools.getName(Skills.Get(sv.skill).getStat(player));
				console.log('${name.pad(20, '.')} ${stat.pad(10, '.')} ${sv.value}');
			});
		});

		console.addAlias('quit', 'exit');
		console.addAlias('skills', 'stats');
		console.addAlias('q', 'exit');

		console.addCommand('ecount', 'Entity Count', [], () -> entityCountCmd(console));
	}

	static function entityCountCmd(console:Console)
	{
		console.log('Entities: ${Game.instance.registry.size}', 0xffff00);
	}
}
