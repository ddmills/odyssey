package domain.terrain.biomes;

import data.TileKey;

class MountainBiome extends BiomeGenerator
{
	public function new(seed:Int)
	{
		super(seed, MOUNTAIN, [0x11253A, 0x2B3534, 0x3d4046]);
	}

	override function getBackgroundTileKey(tile:MapTile):TileKey
	{
		return SWAMP_1;
	}
}
