package domain.terrain;

import common.algorithm.Bresenham;
import common.struct.IntPoint;
import common.struct.WeightedTable;
import core.Game;
import data.BiomeMap.BiomeChunkData;
import data.BiomeType;
import data.ColorKey;
import data.SpawnableType;
import domain.prefabs.Spawner;
import hxd.Rand;

class ChunkGen
{
	private var seed(get, null):Int;
	private var world(get, null):World;
	private var riverWidth:Int = 8;

	var table:WeightedTable<SpawnableType>;

	public function new()
	{
		table = new WeightedTable();
		table.add(TABLE, 3);
		table.add(CHAIR, 3);
		table.add(CABINET, 3);
		table.add(TALL_CABINET, 3);
		table.add(SHELF, 3);
		table.add(BOOKSHELF, 3);
		table.add(WAGON_WHEEL, 3);
		table.add(CAMPFIRE, 5);
		table.add(LANTERN, 4);
		table.add(SNAKE, 6);
		table.add(STICK, 3);
		table.add(CHEST, 3);
		table.add(LOCKBOX, 1);
		table.add(SNUB_NOSE_REVOLVER, 1);
		table.add(REVOLVER, 1);
		table.add(NAVY_REVOLVER, 1);
		table.add(RIFLE_AMMO, 2);
		table.add(PISTOL_AMMO, 2);
		table.add(SHOTGUN_AMMO, 2);
		table.add(VIAL, 2);
		table.add(RIFLE, 4);
		table.add(PONCHO, 1);
		table.add(DUSTER, 2);
		table.add(LONG_JOHNS, 3);
		table.add(COACH_GUN, 3);
		table.add(THUG, 4);
		table.add(THUG_2, 4);
		table.add(TOMBSTONE, 4);
		table.add(BOOTS, 4);
		table.add(PANTS, 4);
		table.add(COWBOY_HAT, 4);
	}

	public function generate(chunk:Chunk)
	{
		var r = new Rand(seed + chunk.chunkId);

		var biomes = chunk.zone.biomes;

		chunk.cells.fillFn((idx) -> generateCell(r, chunk, biomes, idx));

		if (biomes.river != null)
		{
			var riverOffset = (((world.chunkSize) - riverWidth) / 2).floor();
			var chunkSize = world.chunkSize - 1;
			var river = biomes.river;
			var polygon = new Array<IntPoint>();

			if (river.n)
			{
				var left = river.nw ? 0 : riverOffset;
				var right = river.ne ? chunkSize : chunkSize - riverOffset;
				polygon.push({
					x: left,
					y: 0,
				});
				polygon.push({
					x: right,
					y: 0,
				});
			}
			if (river.e)
			{
				var top = river.ne ? 0 : riverOffset;
				var bottom = river.se ? chunkSize : chunkSize - riverOffset;
				polygon.push({
					x: chunkSize,
					y: top,
				});
				polygon.push({
					x: chunkSize,
					y: bottom,
				});
			}
			if (river.s)
			{
				var left = river.sw ? 0 : riverOffset;
				var right = river.se ? chunkSize : chunkSize - riverOffset;
				polygon.push({
					x: right,
					y: chunkSize,
				});
				polygon.push({
					x: left,
					y: chunkSize,
				});
			}
			if (river.w)
			{
				var top = river.nw ? 0 : riverOffset;
				var bottom = river.sw ? chunkSize : chunkSize - riverOffset;
				polygon.push({
					x: 0,
					y: bottom,
				});
				polygon.push({
					x: 0,
					y: top,
				});
			}

			// todo: shouldn't have to bresenham stroke when filling
			Bresenham.strokePolygon(polygon, (p) -> setWater(chunk, p));
			Bresenham.fillPolygon(polygon, (p) -> setWater(chunk, p));
		}

		var poi = chunk.zone.poi;

		if (poi != null)
		{
			poi.generate();
		}

		generateRailroad(chunk, r);
		var tl = chunk.getZoneLocalOffset();

		for (cell in chunk.cells)
		{
			var worldPos = chunk.worldPos.add(cell.pos);

			if (poi != null)
			{
				var zPos = tl.add(cell.pos);
				var tile = poi.getTile(zPos);
				if (tile != null)
				{
					for (content in tile.content)
					{
						Spawner.Spawn(content.spawnableType, worldPos.asWorld(), content.spawnableSettings);
					}
					continue;
				}
			}

			if (cell.value.isRailroad)
			{
				continue;
			}

			if (cell.value.terrain != TERRAIN_RIVER && r.bool(.01))
			{
				var loot = table.pick(r);
				Spawner.Spawn(loot, worldPos.asWorld());
			}
			else
			{
				var b = world.map.getBiome(cell.value.biomeKey);
				b.spawnEntity(worldPos, cell.value);
			}
		}
	}

	function addRailroadTrack(chunk:Chunk, pos:IntPoint)
	{
		var cell = chunk.getCell(pos);
		Spawner.Spawn(RAILROAD, chunk.worldPos.add(pos).asWorld());
		cell.isRailroad = true;
	}

	function generateRailroad(chunk:Chunk, r:Rand)
	{
		var zone = chunk.zone;
		var zoneSize = Game.instance.world.zoneSize;
		var halfZoneSize = (zoneSize / 2).floor();
		var connections = zone.getRailroadConnections();
		var hasRailroad = false;

		if (connections.west.length > 0)
		{
			for (x in 0...halfZoneSize)
			{
				var p = zone.worldPos.add(x, halfZoneSize);
				if (chunk.hasWorldPoint(p))
				{
					hasRailroad = true;
					var localPos = p.sub(chunk.worldPos);
					addRailroadTrack(chunk, localPos);
				}
			}
		}

		if (connections.east.length > 0)
		{
			for (x in(halfZoneSize + 1)...zoneSize)
			{
				var p = zone.worldPos.add(x, halfZoneSize);

				if (chunk.hasWorldPoint(p))
				{
					hasRailroad = true;
					var localPos = p.sub(chunk.worldPos);
					addRailroadTrack(chunk, localPos);
				}
			}
		}

		if (connections.north.length > 0)
		{
			for (y in 0...halfZoneSize)
			{
				var p = zone.worldPos.add(halfZoneSize, y);

				if (chunk.hasWorldPoint(p))
				{
					hasRailroad = true;
					var localPos = p.sub(chunk.worldPos);
					addRailroadTrack(chunk, localPos);
				}
			}
		}

		if (connections.south.length > 0)
		{
			for (y in(halfZoneSize + 1)...zoneSize)
			{
				var p = zone.worldPos.add(halfZoneSize, y);

				if (chunk.hasWorldPoint(p))
				{
					hasRailroad = true;
					var localPos = p.sub(chunk.worldPos);
					addRailroadTrack(chunk, localPos);
				}
			}
		}

		var middle = zone.worldPos.add(halfZoneSize, halfZoneSize);
		if (hasRailroad && chunk.hasWorldPoint(middle))
		{
			addRailroadTrack(chunk, chunk.worldPos.sub(middle));
		}
	}

	function pickBiome(r:Rand, pos:IntPoint, biomes:BiomeChunkData):BiomeType
	{
		var x = pos.x / world.chunkSize;
		var y = pos.y / world.chunkSize;

		var isSouth = r.bool(y);
		var isEast = r.bool(x);

		return switch [isSouth, isEast]
		{
			case [true, true]: biomes.se;
			case [true, false]: biomes.sw;
			case [false, true]: biomes.ne;
			case [false, false]: biomes.nw;
		}
	}

	function generateCell(r:Rand, chunk:Chunk, biomes:BiomeChunkData, idx:Int):Cell
	{
		var pos = chunk.getCellCoord(idx);
		var biomeKey = pickBiome(r, pos, biomes);
		var biome = world.map.getBiome(biomeKey);

		var cell:Cell = {
			idx: idx,
			terrain: TERRAIN_GRASS,
			biomeKey: biomeKey,
			tileKey: GRASS_V1_1,
			primary: 0x000000,
			secondary: 0x000000,
			background: 0x000000,
			isRailroad: false,
		};

		var worldPos = pos.add(chunk.worldPos);

		biome.setCellData(worldPos, cell);

		return cell;
	}

	inline function get_seed():Int
	{
		return Game.instance.world.seed;
	}

	inline function get_world():World
	{
		return Game.instance.world;
	}

	function setWater(chunk:Chunk, p:IntPoint)
	{
		var cell = chunk.cells.get(p.x, p.y);
		cell.terrain = TERRAIN_RIVER;
		cell.primary = C_BLUE_2;
		cell.background = C_BLUE_3;
		cell.tileKey = WATER_4;
	}
}
