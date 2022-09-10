package core;

import common.util.Serial;
import core.input.Command;
import data.Commands;
import data.save.SaveChunk;
import domain.components.Health;
import domain.components.Stats;
import domain.skills.Skills;
import h2d.Console;
import haxe.EnumTools;

class ConsoleConfig
{
	static var SAVE_DATA:String;

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

		console.addCommand('save', 'save', [{name: 'chunk index', t: AInt}], (idx:Int) ->
		{
			// var p = Game.instance.world.player.entity;
			// var data = p.save();
			// var save = Serial.Serialize(data);
			// trace(save);
			// var deser = Serial.Deserialize(save);
			// deser.id = 'test';
			// var c = Entity.Load(deser);
			// c.pos = new Coordinate(28, 37, WORLD);
			trace('saving...', idx);
			var chunk = Game.instance.world.chunks.getChunkById(idx);
			var data = chunk.save();

			SAVE_DATA = Serial.Serialize(data);
			chunk.unload();
		});

		console.addCommand('load', 'load', [{name: 'chunk index', t: AInt}], (idx:Int) ->
		{
			// var p = Game.instance.world.player.entity;
			// var data = p.save();
			// var save = Serial.Serialize(data);
			// trace(save);
			// var deser = Serial.Deserialize(save);
			// deser.id = 'test';
			// var c = Entity.Load(deser);
			// c.pos = new Coordinate(28, 37, WORLD);
			trace('loading...', idx);
			var chunk = Game.instance.world.chunks.getChunkById(idx);
			var data:SaveChunk = Serial.Deserialize(SAVE_DATA);
			chunk.load(data);
			Game.instance.world.reapplyVisible();
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

		console.addCommand('heal', 'Heal the player', [], () ->
		{
			var player = Game.instance.world.player.entity;
			var health = player.get(Health);
			health.value = health.max;
		});

		console.addAlias('quit', 'exit');
		console.addAlias('q', 'exit');
		console.addAlias('skills', 'stats');
		console.addAlias('hp', 'heal');

		console.addCommand('ecount', 'Entity Count', [], () -> entityCountCmd(console));
	}

	static function entityCountCmd(console:Console)
	{
		console.log('Entities: ${Game.instance.registry.size}', 0xffff00);
	}
}
