package domain.terrain;

import common.algorithm.Bresenham;
import common.struct.IntPoint;
import common.struct.WeightedTable;
import core.Game;
import data.BiomeMap.BiomeChunkData;
import data.BiomeType;
import data.ColorKeys;
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

		for (cell in chunk.cells)
		{
			var pos = chunk.worldPos.add(cell.pos);

			if (cell.value.terrain != TERRAIN_RIVER && r.bool(.01))
			{
				var loot = table.pick(r);
				Spawner.Spawn(loot, pos.asWorld());
			}
			else
			{
				var b = world.map.getBiome(cell.value.biomeKey);
				b.spawnEntity(pos, cell.value);
			}
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
		cell.primary = ColorKeys.C_BLUE_2;
		cell.background = ColorKeys.C_BLUE_3;
		cell.tileKey = WATER_4;
	}
}
