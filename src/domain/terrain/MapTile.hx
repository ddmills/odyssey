package domain.terrain;

import common.struct.IntPoint;
import core.Game;
import data.BiomeType;
import data.TileKey;
import data.save.SaveWorld.SaveMapTile;
import domain.terrain.biomes.BiomeGenerator;

@:structInit class MapTile
{
	public var idx(default, null):Int;
	public var terrain:TerrainType;
	public var biomes:Map<BiomeType, Float> = new Map();
	public var biomeKey:BiomeType = PRAIRIE;
	public var color:Int;
	public var bgTileKey:TileKey;
	public var bgColor:Int;

	public var map(get, null):MapData;
	public var biome(get, never):BiomeGenerator;
	public var isWater(get, never):Bool;
	public var isImpassable(get, never):Bool;
	public var x(get, never):Int;
	public var y(get, never):Int;
	public var pos(get, never):IntPoint;

	public function new(idx:Int)
	{
		this.idx = idx;
		bgColor = Game.instance.CLEAR_COLOR;
	}

	public function save():SaveMapTile
	{
		return {
			idx: idx,
			terrain: terrain,
			biomes: biomes,
			biomeKey: biomeKey,
			color: color,
			bgTileKey: bgTileKey,
			bgColor: bgColor,
		}
	}

	public static function load(data:SaveMapTile):MapTile
	{
		var t = new MapTile(data.idx);
		t.idx = data.idx;
		t.terrain = data.terrain;
		t.biomes = data.biomes;
		t.biomeKey = data.biomeKey;
		t.color = data.color;
		t.bgTileKey = data.bgTileKey;
		t.bgColor = data.bgColor;
		return t;
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

	inline function get_map():MapData
	{
		return Game.instance.world.map;
	}
}
