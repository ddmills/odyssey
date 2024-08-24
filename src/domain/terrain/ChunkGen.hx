package domain.terrain;

import common.algorithm.Bresenham;
import common.rand.Perlin;
import common.struct.Coordinate;
import common.struct.IntPoint;
import common.struct.WeightedTable;
import common.util.Colors;
import core.Game;
import data.BiomeMap.BiomeZoneData;
import data.BiomeMap.RiverData;
import data.BiomeMap;
import data.BiomeType;
import data.ColorKey;
import data.LiquidType;
import data.SpawnableType;
import domain.prefabs.Spawner;
import domain.terrain.biomes.Biomes;
import hxd.Rand;

typedef BiomeWeights =
{
	se:Float,
	sw:Float,
	ne:Float,
	nw:Float,
}

class ChunkGen
{
	private var seed(get, null):Int;
	private var world(get, null):World;
	private var riverWidth:Int = 4;

	var table:WeightedTable<SpawnableType>;

	public function new()
	{
		table = new WeightedTable();
		table.add(SIGNPOST, 2);
		table.add(WOOD_CROSS, 2);
		table.add(WAGON_WHEEL, 3);
		table.add(CAMPFIRE, 7);
		table.add(LANTERN, 4);
		// table.add(SNAKE, 6);
		// table.add(WOLF, 6);
		// table.add(BAT, 6);
		// table.add(BROWN_BEAR, 6);
		// table.add(THUG, 4);
		// table.add(THUG_2, 4);
		table.add(STICK, 3);
		table.add(CHEST, 3);
		table.add(JAR, 1);
		table.add(LOCKBOX, 1);
		table.add(SNUB_NOSE_REVOLVER, 1);
		table.add(REVOLVER, 1);
		table.add(RIFLE, 4);
		table.add(NAVY_REVOLVER, 1);
		table.add(RIFLE_AMMO, 2);
		table.add(PISTOL_AMMO, 2);
		table.add(SHOTGUN_AMMO, 2);
		table.add(VIAL, 2);
		table.add(PONCHO, 1);
		table.add(DUSTER, 1);
		table.add(LONG_JOHNS, 1);
		table.add(COACH_GUN, 3);
		table.add(TOMBSTONE, 4);
		table.add(BOOTS, 4);
		table.add(PANTS, 2);
		table.add(COWBOY_HAT, 2);
	}

	public function generate(chunk:Chunk)
	{
		var r = new Rand(seed + chunk.chunkId);

		var biomes = chunk.zone.biomes;

		chunk.cells.fillFn((idx) -> generateCell(r, chunk, biomes, idx));

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

			var p1 = new Perlin(2);
			var p2 = new Perlin(3);
			var hasRiver = pickRiver(p1, p2, worldPos, biomes);

			if (hasRiver)
			{
				setWater(chunk, cell.pos);
			}

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
				if (r.bool(.2))
				{
					var biome = Biomes.get(cell.value.biomeKey);
					var e = biome.enemies.pick(r);
					if (e != null)
					{
						Spawner.Spawn(e, worldPos.asWorld());
					}
				}
				var loot = table.pick(r);
				Spawner.Spawn(loot, worldPos.asWorld());
			}
			else
			{
				var b = Biomes.get(cell.value.biomeKey);
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
			hasRailroad = true;
			for (x in 0...halfZoneSize)
			{
				var p = zone.worldPos.add(x, halfZoneSize);
				if (chunk.hasWorldPoint(p))
				{
					var localPos = p.sub(chunk.worldPos);
					addRailroadTrack(chunk, localPos);
				}
			}
		}

		if (connections.east.length > 0)
		{
			hasRailroad = true;
			for (x in (halfZoneSize + 1)...zoneSize)
			{
				var p = zone.worldPos.add(x, halfZoneSize);

				if (chunk.hasWorldPoint(p))
				{
					var localPos = p.sub(chunk.worldPos);
					addRailroadTrack(chunk, localPos);
				}
			}
		}

		if (connections.north.length > 0)
		{
			hasRailroad = true;
			for (y in 0...halfZoneSize)
			{
				var p = zone.worldPos.add(halfZoneSize, y);

				if (chunk.hasWorldPoint(p))
				{
					var localPos = p.sub(chunk.worldPos);
					addRailroadTrack(chunk, localPos);
				}
			}
		}

		if (connections.south.length > 0)
		{
			hasRailroad = true;
			for (y in (halfZoneSize + 1)...zoneSize)
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

	function pickBiome(p1:Perlin, p2:Perlin, worldPos:Coordinate, biomes:BiomeZoneData):BiomeType
	{
		var x = (worldPos.x % world.zoneSize) / world.zoneSize;
		var y = (worldPos.y % world.zoneSize) / world.zoneSize;

		var isSouth = p1.get(worldPos.x, worldPos.y, 35, 5) < y;
		var isEast = p2.get(worldPos.x, worldPos.y, 35, 5) < x;

		return switch [isSouth, isEast]
		{
			case [true, true]: biomes.se;
			case [true, false]: biomes.sw;
			case [false, true]: biomes.ne;
			case [false, false]: biomes.nw;
		}
	}

	function pickRiver(p1:Perlin, p2:Perlin, worldPos:IntPoint, zone:BiomeZoneData):Bool
	{
		if (!BiomeMap.HasRiver(zone))
		{
			return false;
		}

		var rivers = zone.river;

		var x = (worldPos.x % world.zoneSize) / world.zoneSize;
		var y = (worldPos.y % world.zoneSize) / world.zoneSize;

		var isSouth = p1.get(worldPos.x, worldPos.y, 30, 2) < y;
		var isEast = p2.get(worldPos.x, worldPos.y, 30, 2) < x;

		return switch [isSouth, isEast]
		{
			case [true, true]: rivers.se;
			case [true, false]: rivers.sw;
			case [false, true]: rivers.ne;
			case [false, false]: rivers.nw;
		}
	}

	private function isUniformBiome(biomes:BiomeZoneData):Bool
	{
		return (biomes.se == biomes.se) && (biomes.se == biomes.sw) && (biomes.se == biomes.ne) && (biomes.se == biomes.nw);
	}

	function generateCell(r:Rand, chunk:Chunk, biomes:BiomeZoneData, idx:Int):Cell
	{
		var p1 = new Perlin(0);
		var p2 = new Perlin(1);
		var pos = chunk.getCellCoord(idx);
		var worldCoordinate = chunk.worldPos.add(pos).asWorld();
		var biomeKey = pickBiome(p1, p2, worldCoordinate, biomes);
		var biome = Biomes.get(biomeKey);

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

		if (!isUniformBiome(biomes))
		{
			var mixBiomeColor = (coord:Coordinate, color:Int) ->
			{
				if (!chunk.hasWorldPoint(coord.toIntPoint()))
				{
					return color;
				}

				var mixBiomeType = pickBiome(p1, p2, coord, biomes);
				var mixBiome = Biomes.get(mixBiomeType);
				// return Colors.Mix(color, mixBiome.background, .25);
				return color;
			}

			if (pos.x > 0 && pos.y > 0 && pos.x < (world.chunkSize) && pos.y < (world.chunkSize))
			{
				var color = cell.background;
				color = mixBiomeColor(worldCoordinate.add(new Coordinate(0, -1)), color);
				color = mixBiomeColor(worldCoordinate.add(new Coordinate(1, 0)), color);
				color = mixBiomeColor(worldCoordinate.add(new Coordinate(0, 1)), color);
				color = mixBiomeColor(worldCoordinate.add(new Coordinate(-1, 0)), color);
				cell.background = color;
			}
		}

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
		if (cell != null)
		{
			cell.terrain = TERRAIN_RIVER;
			cell.primary = C_BLUE;
			// cell.background = C_BLUE;
			cell.tileKey = WATER_4;
			// cell.tileKey = TERRAIN_BASIC_1;

			// Spawner.Spawn(PUDDLE, p.add(chunk.worldPos).asWorld(), {
			// 	liquidType: LiquidType.LIQUID_WATER,
			// 	volume: 1000,
			// });
		}
	}
}
