package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKey;
import data.TileKey;
import domain.prefabs.Spawner;

class DesertBiome extends Biome
{
	public function new(seed:Int)
	{
		super(seed, DESERT, C_DARK_RED, C_DARK_GREEN, C_RED);
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		if (r.bool(.1))
		{
			cell.tileKey = GRASS_V1_1;
			cell.terrain = TERRAIN_GRASS;
			cell.primary = C_BROWN;
		}
		else
		{
			var c = r.pick([C_BROWN, C_DARK_BROWN, C_DARK_RED]);
			var t = r.pick([TERRAIN_BASIC_1, TERRAIN_BASIC_2, TERRAIN_BASIC_3]);
			cell.tileKey = t;
			cell.terrain = TERRAIN_SAND;
			cell.primary = c;
		}

		cell.background = C_YELLOW;
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_SAND)
		{
			var rocks = perlin.get(pos, 8, 8);
			if (rocks > .6)
			{
				Spawner.Spawn(DESERT_ROCK, pos.asWorld());
			}
			else if (r.bool(.05))
			{
				Spawner.Spawn(CACTUS, pos.asWorld());
			}
		}
	}
}
