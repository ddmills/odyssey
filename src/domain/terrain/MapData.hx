package domain.terrain;

import common.rand.PoissonDiscSampler;
import common.struct.IntPoint;
import core.Game;
import data.BiomeType;
import data.save.SaveWorld.SaveMap;
import domain.terrain.biomes.Biome;
import domain.terrain.biomes.Biomes;
import hxd.Rand;
import mapgen.towns.PoiCriteria;

typedef TownData =
{
	pos:IntPoint,
	chunks:Array<Int>,
}

typedef EstablishedTown =
{
	name:String,
	criteria:PoiCriteria,
}

class MapData
{
	private var world(get, never):World;
	private var seed(get, never):Int;
	private var r:Rand;

	private var towns:Array<TownData>;
	private var biomes:Biomes;

	public function new()
	{
		biomes = new Biomes();
		towns = new Array();
	}

	public function initialize()
	{
		biomes.initialize(seed);
	}

	public function generate()
	{
		for (zone in world.zones.zones)
		{
			zone.value.isTown = false;
		}

		// r = new Rand(world.seed);
		r = Rand.create();

		var townTemplates:Array<EstablishedTown> = [
			{
				name: 'Esperloosa',
				criteria: {
					river: false,
					biomes: [DESERT, TUNDRA],
				},
			},
			{
				name: 'Test',
				criteria: {
					river: false,
					biomes: [DESERT],
				},
			},
			{
				name: 'Test',
				criteria: {
					river: false,
					biomes: [PRAIRIE],
				},
			},
			{
				name: 'Test',
				criteria: {
					river: false,
					biomes: [TUNDRA],
				},
			},
			{
				name: 'Test',
				criteria: {
					river: false,
					biomes: [FOREST],
				},
			},
			{
				name: 'Test',
				criteria: {
					river: false,
					biomes: [FOREST],
				},
			},
			{
				name: 'Test',
				criteria: {
					river: false,
					biomes: [FOREST],
				},
			}
		];

		var poisson = new PoissonDiscSampler(world.zoneCountX, world.zoneCountY, 4, seed);

		var candidates = poisson.all();

		towns = new Array();

		while (townTemplates.length > 0 && candidates.length > 0)
		{
			var c = r.pickIdx(candidates);
			var pos = candidates[c];
			candidates.splice(c, 1);

			for (template in townTemplates)
			{
				var zone = matchZone(pos, template.criteria);

				if (zone == null)
				{
					continue;
				}

				zone.isTown = true;
				townTemplates.remove(template);
				break;
			}
		}
	}

	function matchZone(pos:IntPoint, criteria:PoiCriteria):Null<Zone>
	{
		if (world.zones.isOutOfBounds(pos))
		{
			return null;
		}

		var zone = world.zones.getZone(pos);

		if (!criteria.biomes.has(zone.primaryBiome))
		{
			return null;
		}

		if (zone.isTown)
		{
			return null;
		}

		if (criteria.river == (zone.biomes.river == null))
		{
			return null;
		}

		return zone;
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
