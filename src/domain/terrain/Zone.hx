package domain.terrain;

import common.struct.IntPoint;
import core.Game;
import data.BiomeMap;
import data.BiomeType;
import domain.terrain.gen.ZonePoi;

typedef ZoneRailroad =
{
	lineIds:Array<Int>,
	stopId:Null<Int>,
};

typedef RailroadConnections =
{
	stopId:Null<Int>,
	north:Array<Int>,
	east:Array<Int>,
	south:Array<Int>,
	west:Array<Int>,
};

class Zone
{
	public var zoneId(default, null):Int;
	public var zonePos(get, never):IntPoint;
	public var worldPos(get, never):IntPoint;
	public var biomes(default, null):BiomeChunkData;
	public var primaryBiome(get, never):BiomeType;
	public var poi(get, never):ZonePoi;
	public var railroad:ZoneRailroad;

	public function new(zoneId:Int)
	{
		this.zoneId = zoneId;
		biomes = BiomeMap.GetAt(zoneId);
	}

	public function getRailroadConnections()
	{
		var connections = {
			stopId: railroad == null ? null : railroad.stopId,
			north: [],
			east: [],
			south: [],
			west: [],
		};

		if (railroad == null)
		{
			return connections;
		}

		var zones = Game.instance.world.zones;
		var zNorth = zones.getZone(zonePos.add(0, -1));
		var zEast = zones.getZone(zonePos.add(1, 0));
		var zSouth = zones.getZone(zonePos.add(0, 1));
		var zWest = zones.getZone(zonePos.add(-1, 0));

		if (zNorth != null && zNorth.railroad != null)
		{
			connections.north = zNorth.railroad.lineIds.intersection(railroad.lineIds, (a, b) -> a == b);
		}

		if (zEast != null && zEast.railroad != null)
		{
			connections.east = zEast.railroad.lineIds.intersection(railroad.lineIds, (a, b) -> a == b);
		}

		if (zSouth != null && zSouth.railroad != null)
		{
			connections.south = zSouth.railroad.lineIds.intersection(railroad.lineIds, (a, b) -> a == b);
		}

		if (zWest != null && zWest.railroad != null)
		{
			connections.west = zWest.railroad.lineIds.intersection(railroad.lineIds, (a, b) -> a == b);
		}

		return connections;
	}

	public function getChunks():Array<Chunk>
	{
		var world = Game.instance.world;
		var baseChunkPos = zonePos.multiply(world.chunksPerZone);
		var chunks = new Array<Chunk>();

		for (x in 0...world.chunksPerZone)
		{
			for (y in 0...world.chunksPerZone)
			{
				var chunkPos = baseChunkPos.add(x, y);
				var chunk = world.chunks.getChunk(chunkPos.x, chunkPos.y);
				chunks.push(chunk);
			}
		}

		return chunks;
	}

	inline function get_primaryBiome():Dynamic
	{
		return [biomes.nw, biomes.ne, biomes.se, biomes.sw].mostFrequent();
	}

	inline function get_zonePos():IntPoint
	{
		return Game.instance.world.zones.getZonePos(zoneId);
	}

	inline function get_poi():ZonePoi
	{
		return Game.instance.world.map.getPOIForZone(zoneId);
	}

	inline function get_worldPos():IntPoint
	{
		return zonePos.multiply(Game.instance.world.zoneSize);
	}
}