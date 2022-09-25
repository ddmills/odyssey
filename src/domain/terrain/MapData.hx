package domain.terrain;

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
	}

	public function save():SaveMap
	{
		return {};
	}

	public function load(data:SaveMap)
	{
		r = new Rand(world.seed);
	}

	public function getBiome(biomeType:BiomeType):Biome
	{
		return biomes.get(biomeType);
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
