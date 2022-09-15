package domain.terrain;

import common.rand.Perlin;
import common.struct.Grid;
import common.struct.IntPoint;
import common.struct.WeightedTable;
import core.Game;
import data.BiomeType;
import domain.terrain.MapTile;
import domain.terrain.TerrainType;
import domain.terrain.biomes.BiomeGenerators;
import hxd.Rand;

class MapData
{
	var perlin:Perlin;
	var world(get, never):World;
	var seed(get, never):Int;
	var heightZoom:Int = 78;

	public var tiles:Grid<MapTile>;

	public var weights:MapWeights;

	public var biomes:BiomeGenerators;

	public function new()
	{
		weights = new MapWeights();
		perlin = new Perlin();
		biomes = new BiomeGenerators();
	}

	public function initialize()
	{
		perlin.seed = seed;
		biomes.initialize(seed);

		tiles = new Grid(world.mapWidth, world.mapHeight);
		tiles.fillFn((idx) -> new MapTile(idx, this));

		trace('generating map. (${world.mapWidth}x${world.mapHeight})');
		weights.initialize();
		generateTerrain();
	}

	public function getPredominantBiome(pos:IntPoint):BiomeType
	{
		var weights = weights.getWeights(pos);
		var t = new WeightedTable<BiomeType>();

		for (b => w in weights)
		{
			// increasing the exponent will increase biome intensity/falloff
			t.add(b, (w.pow(3) * 100).round());
		}

		var r = new Rand(seed + tiles.idx(pos.x, pos.y));
		return t.pick(r);
	}

	public function getTile(pos:IntPoint):MapTile
	{
		return tiles.get(pos.x, pos.y);
	}

	public function getColor(pos:IntPoint):Int
	{
		return tiles.get(pos.x, pos.y).color;
	}

	function generateTerrain()
	{
		var r = new Rand(seed);
		for (t in tiles)
		{
			var tile = t.value;
			tile.height = perlin.get(tile.x, tile.y, heightZoom);
			tile.terrain = heightToTerrain(tile.height);
			tile.biomes = weights.getWeights(t.pos);
			tile.predominantBiome = getPredominantBiome(t.pos);

			var biome = biomes.get(tile.predominantBiome);

			tile.color = r.pick(biome.colors);
			tile.bgTileKey = biome.getBackgroundTileKey(tile);
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
