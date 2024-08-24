package domain.terrain.biomes;

import data.BiomeType;

class Biomes
{
	public static var biomes:Array<Biome>;

	public static var BIOME_PRAIRIE:Biome;
	public static var BIOME_FOREST:Biome;
	public static var BIOME_DESERT:Biome;
	public static var BIOME_TUNDRA:Biome;
	public static var BIOME_SWAMP:Biome;
	public static var BIOME_MOUNTAIN:Biome;

	public function new() {}

	public function initialize(seed:Int)
	{
		BIOME_PRAIRIE = new PrairieBiome(seed + 1);
		BIOME_FOREST = new ForestBiome(seed + 2);
		BIOME_DESERT = new DesertBiome(seed + 3);
		BIOME_TUNDRA = new TundraBiome(seed + 4);
		BIOME_SWAMP = new SwampBiome(seed + 5);
		BIOME_MOUNTAIN = new MountainBiome(seed + 6);
		biomes = [
			BIOME_PRAIRIE,
			BIOME_FOREST,
			BIOME_DESERT,
			BIOME_TUNDRA,
			BIOME_SWAMP,
			BIOME_MOUNTAIN,
		];
	}

	public static function get(type:BiomeType):Biome
	{
		return switch type
		{
			case PRAIRIE: BIOME_PRAIRIE;
			case FOREST: BIOME_FOREST;
			case DESERT: BIOME_DESERT;
			case TUNDRA: BIOME_TUNDRA;
			case SWAMP: BIOME_SWAMP;
			case MOUNTAIN: BIOME_MOUNTAIN;
		}
	}
}
