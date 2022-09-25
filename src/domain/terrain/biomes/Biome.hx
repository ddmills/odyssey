package domain.terrain.biomes;

import common.rand.Perlin;
import common.struct.IntPoint;
import data.BiomeType;
import data.ColorKeys;
import data.TileKey;
import domain.terrain.Cell;
import hxd.Rand;

typedef BiomeCellData =
{
	terrain:TerrainType,
	color:Int,
	bgTileKey:TileKey,
	bgColor:Int,
};

class Biome
{
	public var seed:Int;
	public var type(default, null):BiomeType;
	public var naturalColor(default, null):Int;

	var r:Rand;
	var perlin:Perlin;

	public function new(seed:Int, type:BiomeType, naturalColor:Int)
	{
		this.seed = seed;
		this.type = type;
		this.naturalColor = naturalColor;

		r = new Rand(seed);
		perlin = new Perlin(seed);
	}

	public function setCellData(pos:IntPoint, cell:Cell)
	{
		cell.terrain = TerrainType.TERRAIN_GRASS;
		cell.tileKey = GRASS_V1_1;
		cell.primary = ColorKeys.C_GREEN_3;
		cell.background = ColorKeys.C_GREEN_4;
	}

	public function spawnEntity(pos:IntPoint, cell:Cell) {}
}
