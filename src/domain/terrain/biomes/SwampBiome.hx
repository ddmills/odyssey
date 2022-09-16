package domain.terrain.biomes;

import common.struct.IntPoint;
import common.util.Colors;
import data.TileKey;
import domain.prefabs.Spawner;

class SwampBiome extends BiomeGenerator
{
	public function new(seed:Int)
	{
		var weights = new MapWeight(hxd.Res.images.map.weight_swamp);
		super(seed, SWAMP, weights, [0x365857, 0x462f43, 0x365857, 0x568160]);
	}

	override function getBackgroundTileKey(tile:MapTile):TileKey
	{
		var p = perlin.get(tile.x, tile.y, 6);
		var h = p.pow(2);

		if (h > .65)
		{
			return SWAMP_V2_3;
		}

		if (h > .5)
		{
			return SWAMP_V2_2;
		}

		if (h > .46)
		{
			return SWAMP_V2_1;
		}

		if (h > .35)
		{
			return TERRAIN_BASIC_3;
		}

		return TERRAIN_BASIC_2;
	}

	override function assignTileData(tile:MapTile)
	{
		var h = perlin.get(tile.x, tile.y, 16, 8);
		var cutoff = .4;

		if (h < cutoff)
		{
			// todo, there has to be a better way to write this formula lol
			var range = 1 - ((1 - h) * (1 / (1 - cutoff)));

			tile.bgTileKey = WATER_1;
			tile.color = Colors.Mix(0x2B4E6E, 0x09141B, range);
			tile.terrain = TERRAIN_WATER;
		}
		else
		{
			tile.bgTileKey = getBackgroundTileKey(tile);
			tile.color = r.pick(colors);
			tile.terrain = TERRAIN_MUD;
		}
	}

	private function getHeight(p:IntPoint):Float
	{
		return perlin.get(p.x, p.y, 16, 8);
	}

	override function spawnEntity(tile:MapTile)
	{
		if (tile.isWater && r.bool(.25))
		{
			// var h = g

			Spawner.Spawn(BALD_CYPRESS, tile.pos.asWorld());
		}
	}
}
