package core;

import common.util.Serial;
import core.input.Command;
import data.Commands;
import data.save.SaveChunk;
import domain.components.Attributes;
import domain.components.Health;
import domain.components.Level;
import domain.prefabs.Spawner;
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

		console.addCommand('save', 'save', [{name: 'chunk index', t: AInt}], (idx:Int) ->
		{
			var p = game.world.player.entity;
			var e = Spawner.Spawn(CAMPFIRE, p.pos);

			var c = e.clone();
			trace(e.save());
			c.x += 3;

			// trace(Meta.getFields(Type.getClass(s)));
			// var c = game.world.player.entity.clone();

			// c.x += 3;
			// trace('primary', c.get(Sprite).primary);
			// trace('primaryOverride', c.get(Sprite).primaryOverride);
			// trace('primaryColor', c.get(Sprite).primaryColor);
			// trace('primaryColor', c.get(Sprite).shader.primary.toColor());

			// trace('saving...', idx);
			// var chunk = game.world.chunks.getChunkById(idx);
			// var data = chunk.save();

			// SAVE_DATA = Serial.Serialize(data);
			// chunk.unload();
		});

		console.addCommand('load', 'load', [{name: 'chunk index', t: AInt}], (idx:Int) ->
		{
			// var p = game.world.player.entity;
			// var data = p.save();
			// var save = Serial.Serialize(data);
			// trace(save);
			// var deser = Serial.Deserialize(save);
			// deser.id = 'test';
			// var c = Entity.Load(deser);
			// c.pos = new Coordinate(28, 37, WORLD);
			trace('loading...', idx);
			var chunk = game.world.chunks.getChunkById(idx);
			var data:SaveChunk = Serial.Deserialize(SAVE_DATA);
			chunk.load(data);
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
