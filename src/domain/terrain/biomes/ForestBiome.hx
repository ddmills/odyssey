package domain.terrain.biomes;

import data.ColorKeys;
import data.TileKey;
import domain.prefabs.Spawner;

class ForestBiome extends BiomeGenerator
{
	public function new(seed:Int)
	{
		var weights = new MapWeight(hxd.Res.images.map.weight_forest);
		super(seed, FOREST, weights, [0x263128, 0x303332, 0x36463a, 0x3A413D]);
	}

	override function getBackgroundTileKey(tile:MapTile):TileKey
	{
		return r.pick([GRASS_V1_1, GRASS_V1_2, GRASS_V1_3]);
	}

	override function assignTileData(tile:MapTile)
	{
		tile.bgTileKey = getBackgroundTileKey(tile);
		// tile.color = r.pick(colors);
		tile.color = ColorKeys.C_GRAY_4;
		tile.terrain = TERRAIN_GRASS;
		// tile.bgColor = 0x0E1A10;
		tile.bgColor = ColorKeys.C_GRAY_5;
	}

	override function spawnEntity(tile:MapTile)
	{
		if (tile.terrain == TERRAIN_GRASS && r.bool(.25))
		{
			Spawner.Spawn(PINE_TREE, tile.pos.asWorld());
		}
	}
}
