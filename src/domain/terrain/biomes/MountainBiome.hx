package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKey;

class MountainBiome extends Biome
{
	public function new(seed:Int)
	{
		super(seed, MOUNTAIN, C_GRAY, C_LIGHT_GRAY, C_GRAY);
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
			cell.tileKey = TERRAIN_BASIC_4;
			cell.terrain = TERRAIN_ROCK;
		}

		cell.primary = C_GRAY;
		cell.background = C_GRAY;
	}
}
