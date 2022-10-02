package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKey;
import data.TileKey;
import domain.prefabs.Spawner;

class PrairieBiome extends Biome
{
	public function new(seed:Int)
	{
		super(seed, PRAIRIE, C_GREEN_3);
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
		if (cell.terrain == TERRAIN_GRASS && r.bool(.005))
		{
			Spawner.Spawn(OAK_TREE, pos.asWorld());
		}
	}
}
