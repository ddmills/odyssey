package domain.terrain.biomes;

import data.BiomeType;

class BiomeGenerators
{
	public static var biomes:Map<BiomeType, BiomeGenerator>;

	public function new() {}

	public function initialize(seed:Int)
	{
		biomes = new Map();
		biomes.set(PRAIRIE, new PrairieBiome(seed + 1));
		biomes.set(FOREST, new ForestBiome(seed + 2));
		biomes.set(DESERT, new DesertBiome(seed + 3));
		biomes.set(TUNDRA, new TundraBiome(seed + 4));
		biomes.set(SWAMP, new SwampBiome(seed + 5));
		biomes.set(MOUNTAIN, new MountainBiome(seed + 6));
	}

	public function get(type:BiomeType):BiomeGenerator
	{
		return biomes.get(type);
	}
}
