package domain.terrain.biomes;

import data.TileKey;

class TundraBiome extends BiomeGenerator
{
	public function new(seed:Int)
	{
		super(seed, TUNDRA, [0x326666, 0x8a6b4f, 0x887F6B, 0x8a7d6e, 0x928C83]);
	}

	override function getBackgroundTileKey(tile:MapTile):TileKey
	{
		return SWAMP_1;
	}
}
