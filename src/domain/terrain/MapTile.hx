package domain.terrain;

import common.struct.IntPoint;
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
	public var isWater(get, never):Bool;

	public var x(get, never):Int;
	public var y(get, never):Int;
	public var pos(get, never):IntPoint;

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

	function get_isBlocker():Bool
	{
		return terrain == TERRAIN_ROCKFACE;
	}

	function get_isWater():Bool
	{
		return terrain == TERRAIN_WATER || terrain == TERRAIN_RIVER;
	}

	function get_pos():IntPoint
	{
		return map.tiles.coord(idx);
	}
}
