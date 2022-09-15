package domain.terrain.biomes;

import data.TileKey;
import domain.prefabs.Spawner;

class DesertBiome extends BiomeGenerator
{
	public function new(seed:Int)
	{
		var weights = new MapWeight(hxd.Res.images.map.weight_desert);
		super(seed, DESERT, weights, [0x947c39, 0x8a6b4f, 0x887F6B, 0x8a7d6e, 0x928C83]);
	}

	override function getBackgroundTileKey(tile:MapTile):TileKey
	{
		return r.pick([SAND_1, SAND_2, SAND_3, SAND_4]);
	}

	override function assignTileData(tile:MapTile)
	{
		tile.bgTileKey = getBackgroundTileKey(tile);
		tile.color = r.pick(colors);
		tile.terrain = TERRAIN_SAND;
	}

	override function spawnEntity(tile:MapTile)
	{
		if (tile.terrain == TERRAIN_SAND && r.bool(.05))
		{
			Spawner.Spawn(CACTUS, tile.pos.asWorld());
		}
	}
}
