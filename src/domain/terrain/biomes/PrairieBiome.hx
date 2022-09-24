package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKeys;
import data.TileKey;
import domain.prefabs.Spawner;

class PrairieBiome extends Biome
{
	var waterLevel:Float = .32;

	public function new(seed:Int)
	{
		var weights = new MapWeight(hxd.Res.images.map.weight_prairie);
		super(seed, PRAIRIE, weights, ColorKeys.C_GREEN_3);
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

	private function getHeight(pos:IntPoint):Float
	{
		return perlin.get(pos.x, pos.y, 30, 5);
	}

	private function getIsWater(pos:IntPoint)
	{
		return getHeight(pos) < waterLevel;
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		var isWater = getIsWater(pos);

		if (isWater)
		{
			cell.tileKey = WATER_1;
			cell.terrain = TERRAIN_WATER;
			cell.primary = ColorKeys.C_BLUE_2;
			cell.background = ColorKeys.C_BLUE_3;
		}
		else
		{
			cell.tileKey = getBackgroundTileKey(pos);
			cell.terrain = TERRAIN_GRASS;
			cell.primary = ColorKeys.C_GREEN_2;
			cell.background = ColorKeys.C_GREEN_3;
		}
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_GRASS && r.bool(.005))
		{
			Spawner.Spawn(OAK_TREE, pos.asWorld());
		}
	}
}
