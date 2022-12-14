package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKey;
import domain.prefabs.Spawner;

class TundraBiome extends Biome
{
	public function new(seed:Int)
	{
		super(seed, TUNDRA, C_GRAY_1, C_BLUE_1, C_GRAY_2);
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		if (r.bool(.35))
		{
			cell.tileKey = GRASS_V1_3;
			cell.terrain = TERRAIN_GRASS;
		}
		else
		{
			cell.tileKey = TERRAIN_BASIC_3;
			cell.terrain = TERRAIN_SNOW;
		}

		cell.primary = C_GRAY_1;
		cell.background = C_GRAY_2;
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_SNOW)
		{
			var perlin = perlin.get(pos, 8, 8);
			if (perlin > .6)
			{
				Spawner.Spawn(PINE_TREE, pos.asWorld());
			}
		}
	}
}
