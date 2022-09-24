package domain.terrain;

import common.struct.Grid;
import common.struct.IntPoint;
import common.struct.WeightedTable;
import common.tools.Performance;
import core.Game;
import data.BiomeType;
import data.save.SaveWorld.SaveMap;
import domain.terrain.biomes.Biome;
import domain.terrain.biomes.Biomes;
import hxd.Rand;

class MapData
{
	private var world(get, never):World;
	private var seed(get, never):Int;
	private var cells:Grid<Cell>;
	private var r:Rand;

	public var biomes:Biomes;

	public function new()
	{
		biomes = new Biomes();
	}

	public function initialize()
	{
		biomes.initialize(seed);
	}

	public function generate()
	{
		r = new Rand(world.seed);

		trace('generating map ${world.mapWidth}x${world.mapHeight} = ${world.mapWidth * world.mapHeight} tiles');
		Performance.start('map-gen');
		cells = new Grid(world.mapWidth, world.mapHeight);
		cells.fillFn(generateCell);
		Performance.stop('map-gen', true);
	}

	public function save():SaveMap
	{
		return {
			cells: cells.save((t) -> t)
		};
	}

	public function load(data:SaveMap)
	{
		r = new Rand(world.seed);
		cells = new Grid(world.mapWidth, world.mapHeight);
		cells.load(data.cells, (d) -> d);
	}

	private function pickBiome(biomes:Map<BiomeType, Float>):BiomeType
	{
		var table = new WeightedTable<BiomeType>();

		for (b => w in biomes)
		{
			if (w > .05)
			{
				// increasing the exponent will increase biome intensity/falloff
				table.add(b, (w.pow(3) * 100).round());
			}
		}

		return table.pick(r);
	}

	public function getCell(pos:IntPoint):Cell
	{
		return cells.get(pos.x, pos.y);
	}

	public function getBiome(biomeType:BiomeType):Biome
	{
		return biomes.get(biomeType);
	}

	public function getTileIdx(pos:IntPoint):Int
	{
		return cells.idx(pos.x, pos.y);
	}

	public function getTilePos(idx:Int):IntPoint
	{
		return cells.coord(idx);
	}

	public function getColor(pos:IntPoint):Int
	{
		return cells.get(pos.x, pos.y).primary;
	}

	inline function generateCell(idx:Int):Cell
	{
		if (idx % 50000 == 0)
		{
			trace('generating.... ${((idx / cells.size) * 100).format()}%');
		}

		var pos = getTilePos(idx);
		// var biomeWeights = biomes.getRelativeWeights(pos);
		var biomeKey = BiomeType.PRAIRIE; // pickBiome(biomeWeights);
		var biome = biomes.get(biomeKey);
		var cell:Cell = {
			idx: idx,
			terrain: TERRAIN_GRASS,
			biomeKey: biomeKey,
			tileKey: GRASS_V1_1,
			primary: 0x000000,
			secondary: 0x000000,
			background: 0x000000,
		};

		biome.setCellData(pos, cell);

		return cell;
	}

	public function isOutOfBounds(pos:IntPoint):Bool
	{
		return cells.isOutOfBounds(pos.x, pos.y);
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
