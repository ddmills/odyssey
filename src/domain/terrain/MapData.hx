package domain.terrain;

import common.struct.Grid;
import common.struct.IntPoint;
import common.struct.WeightedTable;
import common.tools.Performance;
import core.Game;
import data.BiomeType;
import data.ColorKeys;
import data.TileKey;
import data.save.SaveWorld.SaveMap;
import domain.terrain.MapTile;
import domain.terrain.biomes.BiomeGenerators;
import hxd.Rand;

class MapData
{
	private var world(get, never):World;
	private var seed(get, never):Int;
	private var r:Rand;

	public var tiles:Grid<MapTile>;
	public var biomes:BiomeGenerators;

	public function new()
	{
		biomes = new BiomeGenerators();
	}

	public function initialize()
	{
		biomes.initialize(seed);
	}

	public function generate()
	{
		r = new Rand(world.seed);

		trace('generating map ${world.mapWidth}x${world.mapHeight} = ${world.mapWidth * world.mapHeight} tiles');
		tiles = new Grid(world.mapWidth, world.mapHeight);
		tiles.fillFn((idx) -> new MapTile(idx));

		Performance.start('map-gen');
		generateTerrain();
		generateRiver();
		trace(Performance.stop('map-gen'));
	}

	public function save():SaveMap
	{
		return {
			tiles: tiles.save((t) -> t.save())
		};
	}

	public function load(data:SaveMap)
	{
		Performance.start('map-load');
		r = new Rand(world.seed);
		tiles = new Grid(world.mapWidth, world.mapHeight);
		tiles.load(data.tiles, (d) ->
		{
			return MapTile.load(d);
		});
		trace(Performance.stop('map-load'));
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

		return table.pick(r);
	}

	public function getTile(pos:IntPoint):MapTile
	{
		return tiles.get(pos.x, pos.y);
	}

	public function getTileIdx(pos:IntPoint):Int
	{
		return tiles.idx(pos.x, pos.y);
	}

	public function getTilePos(idx:Int):IntPoint
	{
		return tiles.coord(idx);
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
			tile.biomes = biomes.getRelativeWeights(t.pos);
			tile.biomeKey = assignBiome(tile);

			var biome = biomes.get(tile.biomeKey);

			biome.assignTileData(tile);
		}
	}

	function generateRiver()
	{
		var variance = 16;
		var middle = (tiles.height / 2).floor();
		var start = r.integer(-variance, variance) + middle;
		var end = r.integer(-variance, variance) + middle;

		var slope = (start - end) / tiles.width;
		var period = 4;
		var intensity = 3.5;
		var startWidth = 6;
		var minWidth = 2;

		for (x in 0...tiles.width)
		{
			var progress = (x / tiles.width);
			var stuf = (1 - progress) * (intensity * intensity);
			var riverWidth = (((1 - progress) * startWidth) + minWidth).round();

			for (y in 0...riverWidth)
			{
				var ry = (slope * x + (Math.sin(x * (1 / period)) * stuf)).round();

				var pos = new IntPoint(x, y + start + ry);

				if (tiles.isOutOfBounds(pos.x, pos.y))
				{
					continue;
				}

				var tile = getTile(pos);
				setTileRiver(tile);
			}
		}
	}

	function setTileRiver(tile:MapTile)
	{
		tile.color = ColorKeys.C_BLUE_2;
		tile.bgColor = ColorKeys.C_BLUE_3;
		tile.terrain = TERRAIN_RIVER;
		var waterTiles:Array<TileKey> = [WATER_1, WATER_2, WATER_3, WATER_4];
		tile.bgTileKey = r.pick(waterTiles);
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
