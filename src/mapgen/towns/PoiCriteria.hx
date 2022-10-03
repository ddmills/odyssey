package mapgen.towns;

import common.struct.IntPoint;
import data.BiomeType;

typedef PoiCriteria =
{
	var biomes:Array<BiomeType>;
	var river:Bool;
	var quadrants:Array<IntPoint>;
}
