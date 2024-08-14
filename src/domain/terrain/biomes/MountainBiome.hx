package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKey;
import data.TileKey;
import domain.prefabs.Spawner;

class MountainBiome extends Biome
{
	public function new(seed:Int)
	{
		super(seed, MOUNTAIN, C_DARK_GRAY, C_GRAY, C_DARK_GRAY);
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		cell.tileKey = r.pick([GRASS_V1_1, GRASS_V1_2, GRASS_V1_3]);
		cell.terrain = TERRAIN_GRASS;
		var c = r.pick([C_DARK_GREEN, C_DARK_BROWN, C_DARK_GRAY]);
		cell.primary = c;
		cell.background = C_GREEN;
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_WATER)
		{
			return;
		}

		var rocks = perlin.get(pos, 10, 3);
		var trees = perlin.get(pos, 8, 8);
		if (rocks > .5)
		{
			Spawner.Spawn(STONE_WALL, pos.asWorld());
		}
		else if (trees > .6)
		{
			if (r.bool(.25 + trees))
			{
				Spawner.Spawn(PINE_TREE, pos.asWorld());
			}
		}
	}
}
