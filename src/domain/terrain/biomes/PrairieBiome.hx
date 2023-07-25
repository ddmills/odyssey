package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKey;
import data.TileKey;
import domain.prefabs.Spawner;

class PrairieBiome extends Biome
{
	public function new(seed:Int)
	{
		super(seed, PRAIRIE, C_GREEN_2, C_GREEN_1, C_GREEN_3);
	}

	function getBackgroundTileKey(pos:IntPoint):TileKey
	{
		var h = perlin.get(pos, 6);

		if (h > .7)
		{
			return GRASS_V2_4;
		}

		if (h > .6)
		{
			return GRASS_V2_3;
		}

		if (h > .5)
		{
			return GRASS_V2_2;
		}

		if (h > .4)
		{
			return GRASS_V2_1;
		}

		return TERRAIN_BASIC_1;
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		cell.tileKey = getBackgroundTileKey(pos);
		cell.terrain = TERRAIN_GRASS;
		cell.primary = C_GREEN_2;
		cell.background = C_GREEN_3;
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_GRASS)
		{
			var h = perlin.get(pos, 6);
			var trees = perlin.get(pos, 8, 8);
			var flowers = perlin.get(pos, 12, 8);

			if (h > .6 && trees > .6)
			{
				Spawner.Spawn(OAK_TREE, pos.asWorld());
			}
			else if (flowers > .78)
			{
				if (r.bool(.5))
				{
					if (r.bool(.5))
					{
						Spawner.Spawn(HEMLOCK, pos.asWorld());
					}
					else
					{
						Spawner.Spawn(YARROW, pos.asWorld());
					}
				}
				else
				{
					Spawner.Spawn(LAVENDER, pos.asWorld());
				}
			}
			else if (r.bool(.005))
			{
				Spawner.Spawn(STICK, pos.asWorld());
			}
		}
	}
}
