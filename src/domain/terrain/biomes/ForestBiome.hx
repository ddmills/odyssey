package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKey;
import data.TileKey;
import domain.prefabs.Spawner;

class ForestBiome extends Biome
{
	public function new(seed:Int)
	{
		super(seed, FOREST, C_GREEN_3, C_RED_2, C_GREEN_4);
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		cell.tileKey = r.pick([GRASS_V1_1, GRASS_V1_2, GRASS_V1_3]);
		cell.terrain = TERRAIN_GRASS;
		cell.primary = C_GREEN_3;
		cell.background = C_GREEN_4;
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_GRASS)
		{
			var trees = perlin.get(pos, 5, 8);
			var rocks = perlin.get(pos, 12, 2);
			if (rocks > .67)
			{
				Spawner.Spawn(ROCK, pos.asWorld());
			}
			else if (trees > .5)
			{
				if (r.bool(.25 + trees))
				{
					Spawner.Spawn(PINE_TREE, pos.asWorld());
				}
			}
		}
	}
}
