package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKeys;
import data.TileKey;
import domain.prefabs.Spawner;

class ForestBiome extends Biome
{
	public function new(seed:Int)
	{
		super(seed, FOREST, ColorKeys.C_GREEN_4);
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		cell.tileKey = r.pick([GRASS_V1_1, GRASS_V1_2, GRASS_V1_3]);
		cell.terrain = TERRAIN_GRASS;
		cell.primary = ColorKeys.C_GREEN_3;
		cell.background = ColorKeys.C_GREEN_4;
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_GRASS)
		{
			var perlin = perlin.get(pos, 8, 8);
			if (perlin > .44)
			{
				if (r.bool(.6))
				{
					Spawner.Spawn(PINE_TREE, pos.asWorld());
				}
			}
		}
	}
}
