package domain.terrain.biomes;

import common.rand.Perlin;
import common.struct.IntPoint;
import data.BiomeType;
import data.TileKey;
import domain.prefabs.Spawner;
import hxd.Rand;

class BiomeGenerator
{
	public var seed:Int;
	public var type(default, null):BiomeType;
	public var colors(default, null):Array<Int>;
	public var naturalColor(get, never):Int;
	public var r:Rand;
	public var perlin:Perlin;

	public var baseWeightMap:MapWeight;

	public function new(seed:Int, type:BiomeType, baseWeightMap:MapWeight, colors:Array<Int>)
	{
		this.seed = seed;
		this.type = type;
		this.colors = colors;
		this.baseWeightMap = baseWeightMap;

		r = new Rand(seed);
		perlin = new Perlin(seed);
	}

	public function getBackgroundTileKey(tile:MapTile):TileKey
	{
		return DOT;
	}

	function get_naturalColor():Int
	{
		return colors[0];
	}

	public function getTerrain(tile:MapTile):TerrainType
	{
		return TERRAIN_GRASS;
	}

	public function assignTileData(tile:MapTile)
	{
		tile.bgTileKey = getBackgroundTileKey(tile);
		tile.color = r.pick(colors);
		tile.terrain = TERRAIN_GRASS;
	}

	public function getWeight(pos:IntPoint):Float
	{
		return baseWeightMap.getWeight(pos);
	}

	public function spawnEntity(tile:MapTile) {}
}
