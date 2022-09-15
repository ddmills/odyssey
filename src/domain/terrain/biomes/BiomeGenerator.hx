package domain.terrain.biomes;

import common.rand.Perlin;
import data.BiomeType;
import data.TileKey;
import hxd.Rand;

class BiomeGenerator
{
	public var seed:Int;
	public var type(default, null):BiomeType;
	public var colors(default, null):Array<Int>;
	public var naturalColor(get, never):Int;
	public var r:Rand;
	public var perlin:Perlin;

	public function new(seed:Int, type:BiomeType, colors:Array<Int>)
	{
		this.seed = seed;
		this.type = type;
		this.colors = colors;

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
}
