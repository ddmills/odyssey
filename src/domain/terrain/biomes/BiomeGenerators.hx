package domain.terrain.biomes;

import common.struct.IntPoint;
import data.BiomeType;
import haxe.ds.EnumValueMap;

class BiomeGenerators
{
	public static var biomes:Array<BiomeGenerator>;

	public static var BIOME_PRAIRIE:BiomeGenerator;
	public static var BIOME_FOREST:BiomeGenerator;
	public static var BIOME_DESERT:BiomeGenerator;
	public static var BIOME_TUNDRA:BiomeGenerator;
	public static var BIOME_SWAMP:BiomeGenerator;
	public static var BIOME_MOUNTAIN:BiomeGenerator;

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

	public function get(type:BiomeType):BiomeGenerator
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

	public function getRelativeWeights(pos:IntPoint):Map<BiomeType, Float>
	{
		var weights = new Map<BiomeType, Float>();
		var sum = 0.0;

		for (biome in biomes)
		{
			var weight = biome.getWeight(pos);
			weights.set(biome.type, weight);
			sum += weight;
		}

		for (type => weight in weights)
		{
			weights.set(type, weight / sum);
		}

		return weights;
	}
}
