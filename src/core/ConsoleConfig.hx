package core;

import common.util.Serial;
import core.input.Command;
import data.Commands;
import domain.components.Attributes;
import domain.components.Health;
import domain.components.Level;
import domain.stats.Stats;
import h2d.Console;
import haxe.EnumTools;

class ConsoleConfig
{
	static var SAVE_DATA:String;

	static var game(get, never):Game;

	public static function Config(console:Console)
	{
		console.log('Type "help" for list of commands.');

		console.addCommand('exit', 'Close the console', [], () ->
		{
			game.screens.pop();
		});

		console.addCommand('cmds', 'List available commands on current screen', [], () ->
		{
			console.log('Available commands', game.TEXT_COLOR_FOCUS);
			Commands.GetForDomains([INPUT_DOMAIN_DEFAULT, game.screens.previous.inputDomain]).each((cmd:Command) ->
			{
				console.log('${cmd.friendlyKey()} - ${cmd.name}', game.TEXT_COLOR_FOCUS);
			});
		});

		console.addCommand('attributes', 'List player attributes & stats', [], () ->
		{
			var player = game.world.player.entity;
			console.log('ATTRIBUTES', game.TEXT_COLOR_FOCUS);
			Attributes.GetAll(player).each((sv) ->
			{
				var name = EnumValueTools.getName(sv.attribute) + ' ';
				console.log('${name.pad(41, '.')} ${sv.value}');
			});

			console.log('STATS', game.TEXT_COLOR_FOCUS);
			Stats.GetAll(player).each((sv:StatValue) ->
			{
				var name = EnumValueTools.getName(sv.stat) + ' ';
				var stat = Stats.Get(sv.stat);
				var attribute = stat.getAttribute(player);
				var atts = attribute == null ? '' : ' ' + EnumValueTools.getName(attribute) + ' ';
				console.log('${name.pad(30, '.')}${atts.pad(10, '.')} ${sv.value}');
			});
		});

		console.addCommand('heal', 'Heal the player', [], () ->
		{
			var player = game.world.player.entity;
			var health = player.get(Health);
			health.value = health.max;
			health.armor = health.armorMax;
		});

		console.addCommand('entity', 'Lookup entity', [{name: 'entityId', t: AString}], (id:String) ->
		{
			var entity = game.registry.getEntity(id);

			if (entity != null)
			{
				var s = entity.save();
				var json = Serial.Serialize(s);
				console.log(json);
			}
			else
			{
				console.log('Entity not found');
			}
		});

		console.addCommand('xp', 'Grant xp', [{name: 'amount', t: AInt}], (xp:Int) ->
		{
			var player = game.world.player.entity;
			var level = player.get(Level);
			level.xp += xp;
		});

		console.addAlias('quit', 'exit');
		console.addAlias('q', 'exit');
		console.addAlias('stats', 'attributes');
		console.addAlias('hp', 'heal');

		console.addCommand('ecount', 'Entity Count', [], () -> entityCountCmd(console));
	}

	static function entityCountCmd(console:Console)
	{
		console.log('Entities: ${game.registry.size}', game.TEXT_COLOR_FOCUS);
	}

	static function get_game():Game
	{
		return Game.instance;
	}
}
