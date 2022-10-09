package domain;

import common.struct.Coordinate;
import common.struct.IntPoint;
import common.tools.Performance;
import core.Game;
import data.AudioKey;
import data.Cardinal;
import data.save.SaveWorld;
import domain.AIManager;
import domain.components.Explored;
import domain.components.IsInventoried;
import domain.components.Visible;
import domain.data.factions.FactionManager;
import domain.events.EntityLoadedEvent;
import domain.prefabs.Spawner;
import domain.systems.SystemManager;
import domain.terrain.Cell;
import domain.terrain.ChunkManager;
import domain.terrain.MapData;
import domain.terrain.ZoneManager;
import ecs.Entity;
import hxd.Rand;

class World
{
	public var game(get, null):Game;
	public var systems(default, null):SystemManager;
	public var clock(default, null):Clock;
	public var ai(default, null):AIManager;
	public var player(default, null):PlayerManager;
	public var zones(default, null):ZoneManager;
	public var chunks(default, null):ChunkManager;
	public var factions(default, null):FactionManager;
	public var spawner(default, null):Spawner;
	public var zoneCountX(default, null):Int = 64;
	public var zoneCountY(default, null):Int = 48;
	public var zoneSize(default, null):Int = 50;
	public var chunksPerZone(default, never):Int = 2;
	public var chunkSize(get, never):Int;
	public var chunkCountX(get, never):Int;
	public var chunkCountY(get, never):Int;
	public var mapWidth(get, null):Int;
	public var mapHeight(get, null):Int;
	public var map(default, null):MapData;
	public var seed:Int = 2;
	public var soundThreshold:Int = 8;

	public var rand:Rand;

	var visible:Array<Coordinate>;

	public function new()
	{
		systems = new SystemManager();

		clock = new Clock();
		factions = new FactionManager();
		ai = new AIManager();
		player = new PlayerManager();
		zones = new ZoneManager();
		chunks = new ChunkManager();
		spawner = new Spawner();

		map = new MapData();
	}

	public function initialize()
	{
		rand = new Rand(seed);
		visible = [];

		factions.initialize();
		spawner.initialize();
		zones.initialize();
		chunks.initialize();
		map.initialize();
		player.initialize();
		systems.initialize();
	}

	public function updateSystems()
	{
		systems.update(game.frame);
	}

	public function playAudio(pos:IntPoint, key:AudioKey):Bool
	{
		if (player.entity.pos.distance(pos.asWorld()) <= soundThreshold)
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
		visible = new Array<Coordinate>();
		Performance.start('map-generate');
		map.generate();
		Performance.stop('map-generate', true);
		player.create();
		player.entity.x = (mapWidth / 2).floor();
		player.entity.y = (mapHeight / 2).floor();
		systems.storylines.addStoryline('wolf');
	}

	public function load(data:SaveWorld)
	{
		Performance.start('world-load');
		seed = data.seed;
		rand = new Rand(seed);
		visible = [];
		clock.setTick(data.tick);
		factions.load(data.factions);
		zones.load(data.zones);
		map.load(data.map);
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
		Performance.start('world-save');
		var playerData = player.save(teardown);
		var mapData = map.save();
		chunks.save(teardown);
		var zoneData = zones.save();

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
			map: mapData,
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

	public overload extern inline function getEntitiesAt(pos:IntPoint):Array<Entity>
	{
		var w = pos.asWorld();
		var idx = pos.asWorld().toChunkIdx();
		var chunk = chunks.getChunkById(idx);
		if (chunk.isNull())
		{
			return new Array<Entity>();
		}
		var local = w.toChunkLocal();
		var ids = chunk.getEntityIdsAt(local.x, local.y);

		return ids.map((id:String) -> game.registry.getEntity(id));
	}

	public overload extern inline function getEntitiesAt(pos:Coordinate):Array<Entity>
	{
		return getEntitiesAt(pos.toWorld().toIntPoint());
	}

	public function getEntitiesInRect(pos:IntPoint, width, height):Array<Entity>
	{
		var entities:Array<Entity> = [];

		for (x in pos.x...(pos.x + width))
		{
			for (y in pos.y...(pos.y + height))
			{
				entities = entities.concat(getEntitiesAt(new IntPoint(x, y)));
			}
		}

		return entities;
	}

	public function getEntitiesInRange(pos:IntPoint, range:Int):Array<Entity>
	{
		var diameter = (range * 2) + 1;
		var topLeft = pos.sub(new IntPoint(range, range));
		return getEntitiesInRect(topLeft, diameter, diameter);
	}

	public function getNeighborEntities(pos:IntPoint):Array<Array<Entity>>
	{
		// todo - just make faster by removing cardinal calls?
		return [
			getEntitiesAt(pos.add(Cardinal.NORTH_WEST.toOffset())), // NORTH_WEST
			getEntitiesAt(pos.add(Cardinal.NORTH.toOffset())), // NORTH
			getEntitiesAt(pos.add(Cardinal.NORTH_EAST.toOffset())), // NORTH_EAST
			getEntitiesAt(pos.add(Cardinal.WEST.toOffset())), // WEST
			getEntitiesAt(pos.add(Cardinal.EAST.toOffset())), // EAST
			getEntitiesAt(pos.add(Cardinal.SOUTH_WEST.toOffset())), // SOUTH_WEST
			getEntitiesAt(pos.add(Cardinal.SOUTH.toOffset())), // SOUTH
			getEntitiesAt(pos.add(Cardinal.SOUTH_EAST.toOffset())), // SOUTH_EAST
		];
	}

	public function reapplyVisible()
	{
		for (pos in visible)
		{
			setVisible(pos);
		}
	}

	public function clearVisible()
	{
		for (value in visible)
		{
			var c = value.toChunk();
			var chunk = chunks.getChunk(c.x, c.y);
			if (chunk == null || !chunk.isLoaded)
			{
				continue;
			}

			var local = value.toChunkLocal().toIntPoint();

			chunk.setExplore(local, true, false);
			for (entity in getEntitiesAt(value.toWorld().toIntPoint()))
			{
				if (entity.has(Visible) && !entity.has(IsInventoried))
				{
					entity.remove(Visible);
				}
			}
		}
		visible = [];
	}

	public function setVisible(pos:Coordinate)
	{
		var c = pos.toChunk();
		var chunk = chunks.getChunk(c.x, c.y);
		if (chunk != null)
		{
			var local = pos.toChunkLocal().toIntPoint();

			chunk.setExplore(local, true, true);
			for (entity in getEntitiesAt(pos.toWorld().toIntPoint()))
			{
				if (!entity.has(Visible))
				{
					entity.add(new Visible());
				}
				if (!entity.has(Explored))
				{
					entity.add(new Explored());
				}
			}
		}
		visible.push(pos);
	}

	public function isExplored(coord:Coordinate)
	{
		var c = coord.toChunk();
		var chunk = chunks.getChunk(c.x, c.y);
		if (chunk.isNull())
		{
			return false;
		}
		var local = coord.toChunkLocal();
		return chunk.exploration.get(local.x.floor(), local.y.floor());
	}

	public function isVisible(coord:Coordinate)
	{
		return visible.exists((v) -> v.toWorld().equals(coord.toWorld().floor()));
	}

	public function explore(coord:Coordinate)
	{
		var c = coord.toChunk();
		var chunk = chunks.getChunk(c.x, c.y);
		if (chunk != null)
		{
			var local = coord.toChunkLocal().toIntPoint();
			chunk.setExplore(local, true, false);

			for (entity in getEntitiesAt(coord.toWorld().toIntPoint()))
			{
				if (!entity.has(Explored))
				{
					entity.add(new Explored());
				}
			}
		}
	}

	public function getCell(pos:IntPoint):Cell
	{
		var cx = (pos.x / chunkSize).floor();
		var cy = (pos.x / chunkSize).floor();
		var chunk = chunks.getChunk(cx, cy);

		if (chunk.isNull())
		{
			return null;
		}

		return chunk.getCell({
			x: (pos.x % chunkSize),
			y: (pos.y % chunkSize),
		});
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
