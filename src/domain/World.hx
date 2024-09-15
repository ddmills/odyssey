package domain;

import common.struct.Coordinate;
import common.struct.IntPoint;
import common.tools.Performance;
import core.Game;
import data.AudioKey;
import data.BiomeType;
import data.save.SaveWorld;
import domain.AIManager;
import domain.data.factions.FactionManager;
import domain.prefabs.Spawner;
import domain.systems.SystemManager;
import domain.terrain.Cell;
import domain.terrain.Overworld;
import ecs.Entity;
import hxd.Rand;

class World
{
	public var game(get, null):Game;
	public var systems(default, null):SystemManager;
	public var clock(default, null):Clock;
	public var ai(default, null):AIManager;
	public var player(default, null):PlayerManager;
	public var factions(default, null):FactionManager;
	public var spawner(default, null):Spawner;
	public var map(default, null):MapManager;
	public var zoneCountX(default, null):Int = 64;
	public var zoneCountY(default, null):Int = 48;
	public var zoneSize(default, null):Int = 40;
	public var chunksPerZone(default, never):Int = 2;
	public var chunkSize(get, never):Int;
	public var chunkCountX(get, never):Int;
	public var chunkCountY(get, never):Int;
	public var mapWidth(get, null):Int;
	public var mapHeight(get, null):Int;
	public var overworld(default, null):Overworld;
	public var seed:Int = 2;

	public var rand:Rand;

	var visible:Array<Coordinate>;

	public function new()
	{
		clock = new Clock();

		systems = new SystemManager();
		factions = new FactionManager();
		ai = new AIManager();
		player = new PlayerManager();
		spawner = new Spawner();
		map = new MapManager();

		overworld = new Overworld();
	}

	public function initialize()
	{
		rand = new Rand(seed);

		factions.initialize();
		spawner.initialize();
		map.initialize();
		overworld.initialize();
		player.initialize();
		systems.initialize();
	}

	public function updateSystems()
	{
		systems.update(game.frame);
	}

	public function playAudio(pos:IntPoint, key:AudioKey, threshold:Int = 16):Bool
	{
		if (player.entity.pos.distance(pos.asWorld()) <= threshold)
		{
			game.audio.play(key);
			return true;
		}

		return false;
	}

	public function newGame(seed:Int)
	{
		this.seed = seed;
		rand = new Rand(seed);
		visible = new Array();
		Performance.start('map-generate');
		overworld.generate();
		Performance.stop('map-generate', true);
		var pos = new Coordinate((mapWidth / 2).floor(), (mapHeight / 2).floor(), WORLD);
		map.chunks.loadChunks(pos.toChunkIdx());
		map.chunks.loadChunk(pos.toChunkIdx());
		player.create(pos);
		systems.storylines.addStoryline('wolf');
	}

	public function load(data:SaveWorld)
	{
		// TODO: REALMS
		Performance.start('world-load');
		seed = data.seed;
		rand = new Rand(seed);
		visible = [];
		clock.setTick(data.tick);
		factions.load(data.factions);
		map.zones.load(data.zones);
		overworld.load(data.overworld);
		player.load(data.player);
		systems.storylines.Load(data.storylines);

		for (id in data.detachedEntities)
		{
			Entity.Load(id);
		}

		Performance.stop('world-load', true);
	}

	public function save(teardown:Bool = false):SaveWorld
	{
		// TODO: REALMS
		Performance.start('world-save');
		var playerData = player.save(teardown);
		var overworldData = overworld.save();
		map.chunks.save(teardown);
		var zoneData = map.zones.save();

		var detachedEntityIds = game.registry.getDetachedEntities();
		var detachedEntities = new Array<EntitySaveData>();

		while (detachedEntityIds.hasNext())
		{
			var id = detachedEntityIds.next();
			var e = game.registry.getEntity(id);
			detachedEntities.push(e.save());
			if (teardown)
			{
				e.destroy();
			}
		}

		var s = {
			seed: seed,
			player: playerData,
			overworld: overworldData,
			zones: zoneData,
			factions: factions.save(),
			chunkSize: chunkSize,
			chunkCountX: chunkCountX,
			chunkCountY: chunkCountY,
			tick: clock.tick,
			detachedEntities: detachedEntities,
			storylines: systems.storylines.save(),
		};

		Performance.stop('world-save', true);

		return s;
	}

	public overload extern inline function getEntitiesAt(worldPos:IntPoint):Array<Entity>
	{
		return map.getEntitiesAt(worldPos);
	}

	public overload extern inline function getEntitiesAt(pos:Coordinate):Array<Entity>
	{
		return getEntitiesAt(pos.toWorld().toIntPoint());
	}

	// TODO: PERFORMANCE this method is SLOW
	public function getEntitiesInRect(worldPos:IntPoint, width:Int, height:Int):Array<Entity>
	{
		return map.getEntitiesInRect(worldPos, width, height);
	}

	public function getEntitiesInRange(worldPos:IntPoint, range:Int):Array<Entity>
	{
		return map.getEntitiesInRange(worldPos, range);
	}

	public function getCurrentBiomeType():BiomeType
	{
		return map.getCurrentBiomeType();
	}

	public function getNeighborEntities(worldPos:IntPoint):Array<Array<Entity>>
	{
		return map.getNeighborEntities(worldPos);
	}

	public function reapplyVisible()
	{
		map.reapplyVisible();
	}

	public function clearVisible()
	{
		map.clearVisible();
	}

	public function setVisible(worldPos:IntPoint)
	{
		return map.isExplored(worldPos);
	}

	public function isExplored(worldPos:IntPoint)
	{
		return map.isExplored(worldPos);
	}

	public function isVisible(worldPos:IntPoint)
	{
		return map.isVisible(worldPos);
	}

	public function getCell(worldPos:IntPoint):Cell
	{
		return map.getCell(worldPos);
	}

	inline function get_game():Game
	{
		return Game.instance;
	}

	inline function get_mapWidth():Int
	{
		return chunkCountX * chunkSize;
	}

	inline function get_mapHeight():Int
	{
		return chunkCountY * chunkSize;
	}

	public inline function isOutOfBounds(pos:IntPoint)
	{
		return pos.x < 0 || pos.y < 0 || pos.x > mapWidth || pos.y > mapHeight;
	}

	public inline function getTileIdx(pos:IntPoint)
	{
		return pos.y * mapWidth + pos.x;
	}

	public inline function getTilePos(idx:Int):IntPoint
	{
		var w = mapWidth;
		return {
			x: Math.floor(idx % w),
			y: Math.floor(idx / w),
		}
	}

	function get_chunkCountX():Int
	{
		return zoneCountX * chunksPerZone;
	}

	function get_chunkCountY():Int
	{
		return zoneCountY * chunksPerZone;
	}

	function get_chunkSize():Int
	{
		return (zoneSize / chunksPerZone).ciel();
	}
}
