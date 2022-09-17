package domain.terrain;

import common.struct.IntPoint;
import core.Game;
import data.BiomeType;
import data.TileKey;
import domain.terrain.biomes.BiomeGenerator;

@:structInit class MapTile
{
	public var idx(default, null):Int;
	public var map(default, null):MapData;
	public var height:Float;
	public var terrain:TerrainType;
	public var islandId:Int;
	public var settlementId:Int;
	public var biomes:Map<BiomeType, Float> = new Map();
	public var biomeKey:BiomeType = PRAIRIE;
	public var biome(get, never):BiomeGenerator;
	public var color:Int;
	public var bgTileKey:TileKey;
	public var bgColor:Int;
	public var isWater(get, never):Bool;
	public var isImpassable(get, never):Bool;

	public var x(get, never):Int;
	public var y(get, never):Int;
	public var pos(get, never):IntPoint;

	public function new(idx:Int, map:MapData)
	{
		this.idx = idx;
		this.map = map;
		bgColor = Game.instance.CLEAR_COLOR;
	}

	inline function get_x():Int
	{
		return map.tiles.x(idx);
	}

	inline function get_y():Int
	{
		return map.tiles.y(idx);
	}

	function get_isCollider():Bool
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

	function get_biome():BiomeGenerator
	{
		return map.biomes.get(biomeKey);
	}

	function get_isImpassable():Bool
	{
		return isWater || terrain == TERRAIN_ROCKFACE;
	}
}
