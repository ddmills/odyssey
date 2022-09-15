package domain.terrain;

import data.BiomeType;
import data.TileKey;

@:structInit class MapTile
{
	public var idx(default, null):Int;
	public var map(default, null):MapData;
	public var height:Float;
	public var terrain:TerrainType;
	public var islandId:Int;
	public var settlementId:Int;
	public var biomes:Map<BiomeType, Float> = new Map();
	public var predominantBiome:BiomeType;
	public var color:Int;
	public var bgTileKey:TileKey;

	public var x(get, never):Int;
	public var y(get, never):Int;

	public function new(idx:Int, map:MapData)
	{
		this.idx = idx;
		this.map = map;
	}

	inline function get_x():Int
	{
		return map.tiles.x(idx);
	}

	inline function get_y():Int
	{
		return map.tiles.y(idx);
	}
}
