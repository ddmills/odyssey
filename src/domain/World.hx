package domain;

import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Game;
import data.Cardinal;
import domain.AIManager;
import domain.components.Energy;
import domain.components.Explored;
import domain.components.Visible;
import domain.systems.SystemManager;
import domain.terrain.ChunkManager;
import ecs.Entity;

class World
{
	public var game(get, null):Game;
	public var systems(default, null):SystemManager;
	public var clock(default, null):Clock;
	public var ai(default, null):AIManager;
	public var player(default, null):PlayerManager;
	public var chunks(default, null):ChunkManager;
	public var chunkSize(default, null):Int = 16;
	public var chunkCountX(default, null):Int = 24;
	public var chunkCountY(default, null):Int = 24;
	public var mapWidth(get, null):Int;
	public var mapHeight(get, null):Int;
	public var map(default, null):MapData;
	public var seed:Int = 123;

	var visible:Array<Coordinate>;

	public function new()
	{
		seed = 1234;
		systems = new SystemManager();

		clock = new Clock();
		ai = new AIManager();
		player = new PlayerManager();
		chunks = new ChunkManager();

		map = new MapData();
	}

	public function initialize()
	{
		visible = new Array<Coordinate>();
		chunks.initialize();
		map.initialize();
		systems.initialize();
		player.initialize();
	}

	public function updateSystems()
	{
		systems.update(game.frame);
	}

	public overload extern inline function getEntitiesAt(pos:IntPoint):Array<Entity>
	{
		var w = pos.asWorld();
		var idx = pos.asWorld().toChunkIdx();
		var chunk = chunks.getChunkById(idx);
		if (chunk == null)
		{
			return new Array<Entity>();
		}
		var local = w.toChunkLocal(chunk.cx, chunk.cy);
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
		return [
			getEntitiesAt(pos.add(Cardinal.NORTH_WEST.toOffset())),
			getEntitiesAt(pos.add(Cardinal.NORTH.toOffset())),
			getEntitiesAt(pos.add(Cardinal.NORTH_EAST.toOffset())),
			getEntitiesAt(pos.add(Cardinal.WEST.toOffset())),
			getEntitiesAt(pos.add(Cardinal.EAST.toOffset())),
			getEntitiesAt(pos.add(Cardinal.SOUTH_WEST.toOffset())),
			getEntitiesAt(pos.add(Cardinal.SOUTH.toOffset())),
			getEntitiesAt(pos.add(Cardinal.SOUTH_EAST.toOffset())),
		];
	}

	public function setVisible(values:Array<Coordinate>)
	{
		for (value in visible)
		{
			var c = value.toChunk();
			var chunk = chunks.getChunk(c.x, c.y);
			if (chunk != null)
			{
				var local = value.toChunkLocal(chunk.cx, chunk.cy);

				chunk.setExplore(local.x.floor(), local.y.floor(), true, false);
				for (entity in getEntitiesAt(value.toWorld().toIntPoint()))
				{
					if (entity.has(Visible))
					{
						entity.remove(Visible);
					}
				}
			}
		}
		for (value in values)
		{
			var c = value.toChunk();
			var chunk = chunks.getChunk(c.x, c.y);
			if (chunk != null)
			{
				var local = value.toChunkLocal(chunk.cx, chunk.cy);

				chunk.setExplore(local.x.floor(), local.y.floor(), true, true);
				for (entity in getEntitiesAt(value.toWorld().toIntPoint()))
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
		}
		visible = values;
	}

	public function isExplored(coord:Coordinate)
	{
		var c = coord.toChunk();
		var chunk = chunks.getChunk(c.x, c.y);
		if (chunk == null)
		{
			return false;
		}
		var local = coord.toChunkLocal(c.x, c.y);
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
			var local = coord.toChunkLocal(c.x, c.y);
			chunk.setExplore(local.x.floor(), local.y.floor(), true, false);

			for (entity in getEntitiesAt(coord.toWorld().toIntPoint()))
			{
				if (!entity.has(Explored))
				{
					entity.add(new Explored());
				}
			}
		}
	}

	inline function get_game():Game
	{
		return Game.instance;
	}

	function get_mapWidth():Int
	{
		return chunkCountX * chunkSize;
	}

	function get_mapHeight():Int
	{
		return chunkCountY * chunkSize;
	}
}
