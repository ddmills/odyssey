package domain.terrain;

import data.BiomeType;
import data.TileKey;

typedef Cell =
{
	idx:Int,
	terrain:TerrainType,
	biomeKey:BiomeType,
	tileKey:TileKey,
	primary:Int,
	secondary:Int,
	background:Int,
	isRailroad:Bool,
}
