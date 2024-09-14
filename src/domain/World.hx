package domain;

import common.struct.Coordinate;
import common.struct.IntPoint;
import common.tools.Performance;
import core.Game;
import data.AudioKey;
import data.BiomeType;
import data.Cardinal;
import data.save.SaveWorld;
import domain.AIManager;
import domain.components.Explored;
import domain.components.IsInventoried;
import domain.components.Visible;
import domain.data.factions.FactionManager;
import domain.prefabs.Spawner;
import domain.systems.SystemManager;
import domain.terrain.Cell;
import domain.terrain.ChunkManager;
import domain.terrain.Overworld;
import domain.terrain.ZoneManager;
import domain.terrain.gen.portals.PortalManager;
import domain.terrain.gen.realms.RealmManager;
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
	public var portals(default, null):PortalManager;
	public var realms(default, null):RealmManager;
	public var spawner(default, null):Spawner;
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
		systems = new SystemManager();

		clock = new Clock();
		factions = new FactionManager();
		portals = new PortalManager();
		realms = new RealmManager();
		ai = new AIManager();
		player = new PlayerManager();
		zones = new ZoneManager();
		chunks = new ChunkManager();
		spawner = new Spawner();

		overworld = new Overworld();
	}

	public function initialize()
	{
		rand = new Rand(seed);
		visible = [];

		factions.initialize();
		portals.initialize();
		realms.initialize();
		spawner.initialize();
		zones.initialize();
		chunks.initialize();
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
		chunks.loadChunks(pos.toChunkIdx());
		chunks.loadChunk(pos.toChunkIdx());
		player.create(pos);
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
		Performance.start('world-save');
		var playerData = player.save(teardown);
		var overworldData = overworld.save();
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

	public overload extern inline function getEntitiesAt(pos:IntPoint):Array<Entity>
	{
		if (realms.hasActiveRealm)
		{
			var ids = realms.activeRealm.getEntityIdsAt(pos);

			return ids.map((id) -> game.registry.getEntity(id));
		}

		var chunkIdx = chunks.getChunkIdxByWorld(pos.x, pos.y);
		var chunk = chunks.getChunkById(chunkIdx);

		if (chunk.isNull())
		{
			return new Array<Entity>();
		}

		var localX = pos.x % chunkSize;
		var localY = pos.y % chunkSize;
		var ids = chunk.getEntityIdsAt(localX, localY);

		return ids.map((id:String) -> game.registry.getEntity(id));
	}

	public overload extern inline function getEntitiesAt(pos:Coordinate):Array<Entity>
	{
		return getEntitiesAt(pos.toWorld().toIntPoint());
	}

	// TODO: this method is SLOW
	public function getEntitiesInRect(pos:IntPoint, width:Int, height:Int):Array<Entity>
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

	public function getCurrentBiome():BiomeType
	{
		var pos = player.pos.toIntPoint();
		var chunkIdx = chunks.getChunkIdxByWorld(pos.x, pos.y);
		var chunk = chunks.getChunkById(chunkIdx);
		return chunk.zone.primaryBiome;
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
			// if in realm, call it, else call chunk
			if (realms.hasActiveRealm)
			{
				var local = realms.activeRealm.worldPositionToRealmLocal(value.toIntPoint());
				realms.activeRealm.setExplore(local, true, false);
			}
			else
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
		}
		visible = [];
	}

	public function setVisible(pos:Coordinate)
	{
		var worldPos = pos.toWorld().toIntPoint();

		if (realms.hasActiveRealm)
		{
			var localPos = realms.activeRealm.worldPositionToRealmLocal(worldPos);
			realms.activeRealm.setExplore(localPos, true, true);
		}
		else
		{
			var c = pos.toChunk();
			var chunk = chunks.getChunk(c.x, c.y);
			if (chunk != null)
			{
				var local = pos.toChunkLocal().toIntPoint();

				chunk.setExplore(local, true, true);
			}
		}

		var light = systems.lights.getTileLight(worldPos);

		for (entity in getEntitiesAt(worldPos))
		{
			if (!entity.has(Visible))
			{
				entity.add(new Visible());
			}
			if (!entity.has(Explored))
			{
				entity.add(new Explored());
			}
			if (light.intensity > 0 && entity.drawable != null)
			{
				entity.drawable.shader.isLit = 1;
				entity.drawable.shader.lightColor = light.color.toHxdColor().toVector();
				entity.drawable.shader.lightIntensity = light.intensity;
			}
		}

		visible.push(pos);
	}

	public function isExplored(coord:Coordinate)
	{
		if (realms.hasActiveRealm)
		{
			var worldPos = coord.toWorld().toIntPoint();
			return realms.activeRealm.isExplored(worldPos);
		}
		else
		{
			var c = coord.toChunk();
			var chunk = chunks.getChunk(c.x, c.y);
			if (chunk.isNull() || !chunk.isLoaded)
			{
				return false;
			}
			var local = coord.toChunkLocal().toIntPoint();
			return chunk.isExplored(local);
		}
	}

	public function isVisible(coord:Coordinate)
	{
		return visible.exists((v) -> v.toWorld().equals(coord.toWorld().floor()));
	}

	public function getCell(pos:IntPoint):Cell
	{
		if (realms.hasActiveRealm)
		{
			var local = realms.activeRealm.worldPositionToRealmLocal(pos);
			return realms.activeRealm.getCell(local.x, local.y);
		}
		else
		{
			var cx = (pos.x / chunkSize).floor();
			var cy = (pos.y / chunkSize).floor();
			var chunk = chunks.getChunk(cx, cy);

			if (chunk.isNull())
			{
				return null;
			}

			return chunk.getCell(pos.x % chunkSize, pos.y % chunkSize,);
		}
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
