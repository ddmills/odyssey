package domain.terrain.biomes;

import data.TileKey;

class SwampBiome extends BiomeGenerator
{
	public function new(seed:Int)
	{
		super(seed, SWAMP, [0x365857, 0x462f43, 0x365857, 0x568160]);
	}

	override function getBackgroundTileKey(tile:MapTile):TileKey
	{
		var p = perlin.get(tile.x, tile.y, 6);
		var h = p.pow(2);

		if (h > .65)
		{
			return SWAMP_5;
		}

		if (h > .5)
		{
			return SWAMP_4;
		}

		if (h > .46)
		{
			return SWAMP_3;
		}

		if (h > .35)
		{
			return SWAMP_2;
		}

		return SWAMP_1;
	}
}
