package domain.terrain;

import common.struct.IntPoint;
import data.BiomeType;

class MapWeights
{
	var biomes:Map<BiomeType, MapWeight>;

	public function new() {}

	public function initialize()
	{
		biomes = new Map();

		var imgs = hxd.Res.images.map;

		biomes.set(DESERT, new MapWeight(imgs.weight_desert));
		biomes.set(PRAIRIE, new MapWeight(imgs.weight_prairie));
		biomes.set(TUNDRA, new MapWeight(imgs.weight_tundra));
		biomes.set(MOUNTAIN, new MapWeight(imgs.weight_mountain));
		biomes.set(FOREST, new MapWeight(imgs.weight_forest));
		biomes.set(SWAMP, new MapWeight(imgs.weight_swamp));
	}

	private function getWeight(p:IntPoint, b:BiomeType):Float
	{
		return biomes.get(b).getWeight(p);
	}

	public function getWeights(p:IntPoint):Map<BiomeType, Float>
	{
		var weights = new Map<BiomeType, Float>();

		var desert = getWeight(p, DESERT);
		var prairie = getWeight(p, PRAIRIE);
		var tundra = getWeight(p, TUNDRA);
		var mountain = getWeight(p, MOUNTAIN);
		var forest = getWeight(p, FOREST);
		var swamp = getWeight(p, SWAMP);

		var sum = desert + prairie + tundra + mountain + forest + swamp;

		weights.set(DESERT, desert / sum);
		weights.set(PRAIRIE, prairie / sum);
		weights.set(TUNDRA, tundra / sum);
		weights.set(MOUNTAIN, mountain / sum);
		weights.set(FOREST, forest / sum);
		weights.set(SWAMP, swamp / sum);

		return weights;
	}
}
