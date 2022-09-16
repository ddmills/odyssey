package domain.terrain.biomes;

import data.TileKey;

class TundraBiome extends BiomeGenerator
{
	public function new(seed:Int)
	{
		var weights = new MapWeight(hxd.Res.images.map.weight_tundra);
		super(seed, TUNDRA, weights, [0x336969, 0x4f688a, 0x6B7D88, 0x6e7b8a, 0x928C83]);
	}

	override function getBackgroundTileKey(tile:MapTile):TileKey
	{
		return DOT;
	}
}
