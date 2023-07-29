package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKey;
import domain.prefabs.Spawner;

class DesertBiome extends Biome
{
	public function new(seed:Int)
	{
		super(seed, DESERT, C_YELLOW_2, C_GREEN_2, C_YELLOW_3);
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		if (r.bool(.02))
		{
			cell.tileKey = GRASS_V1_3;
			cell.terrain = TERRAIN_GRASS;
		}
		else
		{
			cell.tileKey = GRASS_V1_3;
			cell.terrain = TERRAIN_SAND;
		}

		cell.primary = C_YELLOW_2;
		cell.background = C_YELLOW_3;
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
