package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKeys;

class MountainBiome extends Biome
{
	public function new(seed:Int)
	{
		super(seed, MOUNTAIN, ColorKeys.C_GRAY_5);
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

		cell.primary = ColorKeys.C_GRAY_2;
		cell.background = ColorKeys.C_GRAY_5;
	}
}
