package data;

@:enum
abstract BiomeType(Int) from Int to Int
{
	var DESERT = 0;
	var PRAIRIE = 1;
	var TUNDRA = 2;
	var MOUNTAIN = 3;
	var SWAMP = 4;
	var FOREST = 5;
}
