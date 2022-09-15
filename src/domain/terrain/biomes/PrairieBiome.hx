package domain.terrain.biomes;

import common.struct.IntPoint;
import common.util.Colors;
import data.TileKey;
import domain.prefabs.Spawner;

class PrairieBiome extends BiomeGenerator
{
	var waterLevel:Float = .32;

	public function new(seed:Int)
	{
		var weights = new MapWeight(hxd.Res.images.map.weight_prairie);
		super(seed, PRAIRIE, weights, [0x2A4B16, 0x304723, 0x46502F, 0x44572e, 0x495228]);
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

	override function getTerrain(tile:MapTile):TerrainType
	{
		return TERRAIN_GRASS;
	}

	private function getHeight(pos:IntPoint):Float
	{
		return perlin.get(pos.x, pos.y, 30, 5);
	}

	private function getIsWater(pos:IntPoint)
	{
		return getHeight(pos) < waterLevel;
	}

	override function getWeight(pos:IntPoint):Float
	{
		var base = baseWeightMap.getWeight(pos);

		if (getIsWater(pos))
		{
			return base * 5;
		}

		return base;
	}

	override function assignTileData(tile:MapTile)
	{
		var isWater = getIsWater(tile.pos);

		if (isWater)
		{
			// todo, there has to be a better way to write this formula lol
			// var range = 1 - ((1 - h) * (1 / (1 - cutoff)));

			tile.bgTileKey = WATER_1;
			tile.color = Colors.Mix(0x225699, 0x152e5f, r.rand());
			tile.terrain = TERRAIN_WATER;
		}
		else
		{
			tile.bgTileKey = getBackgroundTileKey(tile);
			tile.color = r.pick(colors);
			tile.terrain = TERRAIN_GRASS;
		}
	}

	override function spawnEntity(tile:MapTile)
	{
		if (tile.terrain == TERRAIN_GRASS && r.bool(.005))
		{
			Spawner.Spawn(OAK_TREE, tile.pos.asWorld());
		}
	}
}
