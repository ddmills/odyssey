package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKeys;
import domain.prefabs.Spawner;

class TundraBiome extends Biome
{
	public function new(seed:Int)
	{
		var weights = new MapWeight(hxd.Res.images.map.weight_tundra);
		super(seed, TUNDRA, weights, ColorKeys.C_GRAY_2);
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

		cell.primary = ColorKeys.C_GRAY_1;
		cell.background = ColorKeys.C_GRAY_2;
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_SNOW && r.bool(.1))
		{
			Spawner.Spawn(PINE_TREE, pos.asWorld());
		}
	}
}
