package domain;

import common.struct.Grid;
import core.Game;
import domain.terrain.MapTile;
import domain.terrain.TerrainType;
import hxd.Perlin;

class MapData
{
	var hxdPerlin:Perlin;
	var world(get, never):World;
	var seed(get, never):Int;
	var heightZoom:Int;

	public var tiles:Grid<MapTile>;

	public function new() {}

	public function initialize()
	{
		hxdPerlin = new Perlin();
		hxdPerlin.normalize = true;
		heightZoom = 78;
		tiles = new Grid(world.mapWidth, world.mapHeight);
		tiles.fillFn((idx) -> new MapTile(idx, this));

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

	public function getTerrain(wx:Float, wy:Float):TerrainType
	{
		return tiles.get(wx.floor(), wy.floor()).terrain;
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
