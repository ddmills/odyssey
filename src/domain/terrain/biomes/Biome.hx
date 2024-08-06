package domain.terrain.biomes;

import common.rand.Perlin;
import common.struct.IntPoint;
import data.BiomeType;
import data.ColorKey;
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
	public var primary(default, null):ColorKey;
	public var secondary(default, null):ColorKey;
	public var background(default, null):ColorKey;

	var r:Rand;
	var perlin:Perlin;

	public function new(seed:Int, type:BiomeType, primary:ColorKey, secondary:ColorKey, background:ColorKey)
	{
		this.seed = seed;
		this.type = type;
		this.primary = primary;
		this.secondary = secondary;
		this.background = background;

		r = new Rand(seed);
		perlin = new Perlin(seed);
	}

	public function setCellData(pos:IntPoint, cell:Cell)
	{
		cell.terrain = TerrainType.TERRAIN_GRASS;
		cell.tileKey = GRASS_V1_1;
		cell.primary = C_DARK_GREEN;
		cell.background = C_DARK_GREEN;
	}

	public function spawnEntity(pos:IntPoint, cell:Cell) {}
}
