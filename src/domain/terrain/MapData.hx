package domain.terrain;

import common.rand.Perlin;
import common.struct.Grid;
import common.struct.IntPoint;
import common.struct.WeightedTable;
import core.Game;
import data.BiomeType;
import domain.terrain.MapTile;
import domain.terrain.biomes.BiomeGenerators;
import hxd.Rand;

class MapData
{
	var perlin:Perlin;
	var world(get, never):World;
	var seed(get, never):Int;
	var heightZoom:Int = 78;
	var r:Rand;

	public var tiles:Grid<MapTile>;
	public var biomes:BiomeGenerators;

	public function new()
	{
		perlin = new Perlin();
		biomes = new BiomeGenerators();
	}

	public function initialize()
	{
		r = new Rand(seed + 1992);
		perlin.seed = seed;
		biomes.initialize(seed);

		tiles = new Grid(world.mapWidth, world.mapHeight);
		tiles.fillFn((idx) -> new MapTile(idx, this));

		trace('generating map. (${world.mapWidth}x${world.mapHeight})');
		generateTerrain();
		trace('generating map done');
	}

	private function assignBiome(tile:MapTile):BiomeType
	{
		var table = new WeightedTable<BiomeType>();

		for (b => w in tile.biomes)
		{
			if (w > .05)
			{
				// increasing the exponent will increase biome intensity/falloff
				table.add(b, (w.pow(3) * 100).round());
			}
		}

		var r = new Rand(seed + tile.idx);
		return table.pick(r);
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
		for (t in tiles)
		{
			var tile = t.value;
			tile.height = perlin.get(tile.x, tile.y, heightZoom);
			tile.biomes = biomes.getRelativeWeights(t.pos);
			tile.biomeKey = assignBiome(tile);

			var biome = biomes.get(tile.biomeKey);

			biome.assignTileData(tile);
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
}
