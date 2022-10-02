package domain.terrain;

import common.rand.PoissonDiscSampler;
import common.struct.IntPoint;
import core.Game;
import data.BiomeType;
import data.PoiLayoutType;
import data.RoomType;
import data.save.SaveWorld.SaveMap;
import domain.terrain.biomes.Biome;
import domain.terrain.biomes.Biomes;
import domain.terrain.gen.ZonePoi;
import hxd.Rand;
import mapgen.towns.PoiCriteria;

typedef RoomTemplate =
{
	type:RoomType,
	?minWidth:Int,
	?minHeight:Int,
	?maxWidth:Int,
	?maxHeight:Int,
}

typedef PoiTemplate =
{
	name:String,
	layout:PoiLayoutType,
	criteria:PoiCriteria,
	rooms:Array<RoomTemplate>,
}

class MapData
{
	private var world(get, never):World;
	private var seed(get, never):Int;
	private var r:Rand;
	private var pois:Array<ZonePoi>;
	private var biomes:Biomes;

	public function new()
	{
		biomes = new Biomes();
		pois = new Array();
	}

	public function initialize()
	{
		biomes.initialize(seed);
	}

	public function generate()
	{
		pois = [];

		// r = new Rand(seed);
		r = Rand.create();

		trace('seed', r.getSeed());

		var poiTemplates:Array<PoiTemplate> = [
			{
				name: 'Esperloosa',
				layout: POI_LAYOUT_SCATTERED,
				criteria: {
					river: false,
					biomes: [TUNDRA, PRAIRIE],
				},
				rooms: [
					{
						type: ROOM_GRAVEYARD,
						minWidth: 8,
						minHeight: 6
					},
					{
						type: ROOM_GRAVEYARD,
					}
				],
			}
		];

		var poisson = new PoissonDiscSampler(world.zoneCountX, world.zoneCountY, 4, seed);
		var candidates = poisson.all();
		var selected:Array<{template:PoiTemplate, zoneId:Int}> = [];

		while (poiTemplates.length > 0 && candidates.length > 0)
		{
			var c = r.pickIdx(candidates);
			var pos = candidates[c];
			candidates.splice(c, 1);

			for (template in poiTemplates)
			{
				var zone = matchZone(pos, template.criteria);

				if (zone == null)
				{
					continue;
				}

				poiTemplates.remove(template);
				selected.push({
					template: template,
					zoneId: zone.zoneId,
				});

				break;
			}
		}

		for (z in selected)
		{
			pois.push(new ZonePoi(z.zoneId, z.template));
		}
	}

	public function getPOIForZone(zoneId:Int):ZonePoi
	{
		return pois.find((t) -> t.zoneId == zoneId);
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
