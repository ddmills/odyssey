package domain.terrain.biomes;

import data.TileKey;

class ForestBiome extends BiomeGenerator
{
	public function new(seed:Int)
	{
		super(seed, FOREST, [0x263128, 0x3a4743, 0x2f5539, 0x354B3E]);
	}

	override function getBackgroundTileKey(tile:MapTile):TileKey
	{
		return r.pick([GRASS_1, GRASS_2, GRASS_3]);
	}
}
