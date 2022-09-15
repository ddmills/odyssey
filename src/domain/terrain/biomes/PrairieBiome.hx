package domain.terrain.biomes;

import data.TileKey;

class PrairieBiome extends BiomeGenerator
{
	public function new(seed:Int)
	{
		super(seed, PRAIRIE, [0x2A4B16, 0x304723, 0x46502F, 0x44572e, 0x495228]);
	}

	public override function getBackgroundTileKey(tile:MapTile):TileKey
	{
		var h = perlin.get(tile.x, tile.y, 6);

		if (h > .7)
		{
			return GRASS_4;
		}

		if (h > .6)
		{
			return GRASS_3;
		}

		if (h > .5)
		{
			return GRASS_V2_3;
		}

		if (h > .4)
		{
			return GRASS_V2_2;
		}

		return GRASS_V2_1;
	}
}
