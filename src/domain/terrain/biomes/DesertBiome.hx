package domain.terrain.biomes;

import data.ColorKeys;
import data.TileKey;
import domain.prefabs.Spawner;

class DesertBiome extends BiomeGenerator
{
	public function new(seed:Int)
	{
		var weights = new MapWeight(hxd.Res.images.map.weight_desert);
		super(seed, DESERT, weights, [0x796632, 0x8a6b4f, 0x887F6B, 0x8a7d6e, 0x928C83]);
	}

	override function getBackgroundTileKey(tile:MapTile):TileKey
	{
		return r.pick([TERRAIN_BASIC_2, TERRAIN_BASIC_3, TERRAIN_BASIC_4]);
	}

	override function assignTileData(tile:MapTile)
	{
		tile.bgTileKey = getBackgroundTileKey(tile);
		tile.terrain = TERRAIN_SAND;
		if (r.bool(.02))
		{
			tile.bgTileKey = GRASS_V1_3;
			tile.terrain = TERRAIN_GRASS;
		}

		tile.color = ColorKeys.C_YELLOW_2;
		tile.bgColor = ColorKeys.C_YELLOW_3;
	}

	override function spawnEntity(tile:MapTile)
	{
		if (tile.terrain == TERRAIN_SAND && r.bool(.05))
		{
			Spawner.Spawn(CACTUS, tile.pos.asWorld());
		}
	}
}
