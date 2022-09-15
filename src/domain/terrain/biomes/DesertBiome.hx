package domain.terrain.biomes;

import data.TileKey;

class DesertBiome extends BiomeGenerator
{
	public function new(seed:Int)
	{
		super(seed, DESERT, [0x947c39, 0x8a6b4f, 0x887F6B, 0x8a7d6e, 0x928C83]);
	}

	override function getBackgroundTileKey(tile:MapTile):TileKey
	{
		return r.pick([SAND_1, SAND_2, SAND_3, SAND_4]);
	}
}
