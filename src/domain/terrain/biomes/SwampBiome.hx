package domain.terrain.biomes;

import common.struct.IntPoint;
import common.util.Colors;
import data.ColorKeys;
import data.TileKey;
import domain.prefabs.Spawner;

class SwampBiome extends BiomeGenerator
{
	var waterLine = .38;

	public function new(seed:Int)
	{
		var weights = new MapWeight(hxd.Res.images.map.weight_swamp);
		super(seed, SWAMP, weights, [0x365857, 0x462f43, 0x365857, 0x568160]);
	}

	override function getBackgroundTileKey(tile:MapTile):TileKey
	{
		var grass = r.bool(.05);
		if (grass)
		{
			return GRASS_V1_3;
		}

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

		// if (h > .4)
		// {
		// 	return TERRAIN_BASIC_3;
		// }

		if (h > .35)
		{
			return TERRAIN_BASIC_2;
		}

		return TERRAIN_BASIC_1;
	}

	override function assignTileData(tile:MapTile)
	{
		var h = perlin.get(tile.x, tile.y, 16, 8);

		if (h < waterLine)
		{
			// todo, there has to be a better way to write this formula lol
			var range = 1 - ((1 - h) * (1 / (1 - waterLine)));

			tile.bgTileKey = WATER_1;
			// tile.color = Colors.Mix(0x2B4E6E, 0x09141B, range);
			tile.color = ColorKeys.C_BLUE_3;
			tile.terrain = TERRAIN_WATER;
			tile.bgColor = 0x09141B;
		}
		else
		{
			tile.bgTileKey = getBackgroundTileKey(tile);
			tile.color = r.pick(colors);
			tile.terrain = TERRAIN_MUD;
			// tile.bgColor = Colors.Mix(0x161115, 0x12271F, h);
			tile.bgColor = ColorKeys.C_PURPLE_3;
		}
	}

	private function getHeight(p:IntPoint):Float
	{
		return perlin.get(p.x, p.y, 16, 8);
	}

	override function spawnEntity(tile:MapTile)
	{
		var h = perlin.get(tile.x, tile.y, 16, 8);

		if (h < waterLine && r.bool(.125))
		{
			// var h = g

			Spawner.Spawn(BALD_CYPRESS, tile.pos.asWorld());
		}
		else if (r.bool(.05))
		{
			Spawner.Spawn(BALD_CYPRESS, tile.pos.asWorld());
		}
	}
}
