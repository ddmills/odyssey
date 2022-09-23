package domain.terrain.biomes;

import data.ColorKeys;
import data.TileKey;

class MountainBiome extends BiomeGenerator
{
	public function new(seed:Int)
	{
		var weights = new MapWeight(hxd.Res.images.map.weight_mountain);
		super(seed, MOUNTAIN, weights, [0x11253A, 0x2B3534, 0x3d4046]);
	}

	override function getBackgroundTileKey(tile:MapTile):TileKey
	{
		return TERRAIN_BASIC_4;
	}

	override function assignTileData(tile:MapTile)
	{
		tile.bgTileKey = getBackgroundTileKey(tile);
		tile.terrain = TERRAIN_ROCK;
		if (r.bool(.02))
		{
			tile.bgTileKey = GRASS_V1_3;
			tile.terrain = TERRAIN_GRASS;
		}

		tile.color = ColorKeys.C_GRAY_2;
		tile.bgColor = ColorKeys.C_GRAY_5;
	}
}
