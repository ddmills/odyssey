package domain.terrain.biomes;

import common.struct.IntPoint;
import core.Game;
import data.ColorKeys;
import domain.prefabs.Spawner;

class DesertBiome extends Biome
{
	public function new(seed:Int)
	{
		var weights = new MapWeight(hxd.Res.images.map.weight_desert);
		super(seed, DESERT, weights, ColorKeys.C_YELLOW_3);
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

		cell.primary = ColorKeys.C_YELLOW_2;
		cell.background = ColorKeys.C_YELLOW_3;
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_SAND && r.bool(.05))
		{
			Spawner.Spawn(CACTUS, pos.asWorld());
		}
	}
}
