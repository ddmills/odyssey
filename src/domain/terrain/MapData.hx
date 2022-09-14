package domain.terrain;

import common.struct.Grid;
import common.struct.IntPoint;
import common.struct.WeightedTable;
import core.Game;
import data.BiomeType;
import data.biomes.GrassBiomeColors;
import domain.terrain.MapTile;
import domain.terrain.TerrainType;
import hxd.Perlin;
import hxd.Rand;

class MapData
{
	var hxdPerlin:Perlin;
	var world(get, never):World;
	var seed(get, never):Int;
	var heightZoom:Int;

	public var tiles:Grid<MapTile>;

	public var weights:MapWeights;

	public function new()
	{
		weights = new MapWeights();
		hxdPerlin = new Perlin();
	}

	public function initialize()
	{
		hxdPerlin.normalize = true;
		heightZoom = 78;
		tiles = new Grid(world.mapWidth, world.mapHeight);
		tiles.fillFn((idx) -> new MapTile(idx, this));

		trace('generating map. (${world.mapWidth}x${world.mapHeight})');
		weights.initialize();
		generateHeight();
		generateTerrain();
	}

	function perlin(x:Float, y:Float, octaves:Int)
	{
		var n = hxdPerlin.perlin(seed, x, y, 8);

		return (n + 1) / 2;
	}

	function generateHeight()
	{
		for (tile in tiles)
		{
			var x = tile.x / heightZoom;
			var y = tile.y / heightZoom;

			tile.value.height = perlin(x, y, 8);
		}
	}

	public function getPredominantBiome(pos:IntPoint):BiomeType
	{
		var weights = weights.getWeights(pos);
		var t = new WeightedTable<BiomeType>();

		for (b => w in weights)
		{
			t.add(b, (w * 100).round());
		}

		var r = new Rand(seed + tiles.idx(pos.x, pos.y));
		return t.pick(r);
	}

	public function getTerrain(pos:IntPoint):TerrainType
	{
		var biome = getPredominantBiome(pos);

		return switch biome
		{
			case DESERT: SAND;
			case _: GRASS;
		}
	}

	public function getColor(pos:IntPoint):Array<Int>
	{
		var biome = getPredominantBiome(pos);
		return GrassBiomeColors.colors.get(biome);
		// var weights = weights.getWeights(pos);
		// if (weights.get(DESERT) > weights.get(PRAIRIE))
		// {
		// 	return GrassBiomeColors.colors.get(DESERT);
		// }
		// else
		// {
		// 	return GrassBiomeColors.colors.get(PRAIRIE);
		// }
	}

	function generateTerrain()
	{
		for (tile in tiles)
		{
			tile.value.terrain = heightToTerrain(tile.value.height);
		}
	}

	public function isOutOfBounds(x:Int, y:Int):Bool
	{
		return tiles.isOutOfBounds(x, y);
	}

	inline function get_world():World
	{
		return Game.instance.world;
	}

	inline function get_seed():Int
	{
		return world.seed;
	}

	function heightToTerrain(h:Float)
	{
		if (h < .45)
		{
			return SAND;
		}

		return GRASS;
	}
}
