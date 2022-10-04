package domain.terrain;

import common.struct.IntPoint;
import core.Game;
import data.BiomeMap;
import data.BiomeType;
import domain.terrain.gen.ZonePoi;

typedef ZoneRailroad =
{
	lineId:Array<Int>,
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
