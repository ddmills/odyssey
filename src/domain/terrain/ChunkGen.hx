package domain.terrain;

import common.struct.IntPoint;
import common.struct.WeightedTable;
import core.Game;
import data.BiomeMap.BiomeChunkData;
import data.BiomeType;
import data.SpawnableType;
import domain.prefabs.Spawner;
import hxd.Rand;

class ChunkGen
{
	private var seed(get, null):Int;
	private var world(get, null):World;

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

		chunk.cells.fillFn((idx) ->
		{
			return generateCell(r, chunk, idx);
		});

		for (cell in chunk.cells)
		{
			var pos = chunk.worldPos.add(cell.pos);

			if (r.bool(.01))
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

	function generateCell(r:Rand, chunk:Chunk, idx:Int):Cell
	{
		var pos = chunk.getCellCoord(idx);
		var biomes = chunk.biomes;
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
}
