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
import domain.terrain.gen.railroad.RailroadData;
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

typedef RailroadTemplate =
{
	stopId:Int,
	fromId:Int,
	toId:Int,
}

typedef PoiTemplate =
{
	name:String,
	layout:PoiLayoutType,
	criteria:PoiCriteria,
	rooms:Array<RoomTemplate>,
	railroad:Null<RailroadTemplate>,
}

class MapData
{
	private var world(get, never):World;
	private var seed(get, never):Int;
	private var r:Rand;
	private var pois:Array<ZonePoi>;
	private var railroad:RailroadData;
	private var biomes:Biomes;

	public function new()
	{
		biomes = new Biomes();
		pois = new Array();
		railroad = new RailroadData();
	}

	public function initialize()
	{
		biomes.initialize(seed);
	}

	public function generate()
	{
		pois = [];
		for (z in world.zones.zones)
		{
			railroad.stops = [];
			z.value.railroad = null;
		}

		// r = new Rand(seed);
		r = Rand.create();

		trace('seed', r.getSeed());

		var poiTemplates:Array<PoiTemplate> = [
			{
				name: 'Esperloosa',
				layout: POI_LAYOUT_SCATTERED,
				railroad: {
					stopId: 0,
					fromId: 4,
					toId: 1,
				},
				criteria: {
					river: false,
					biomes: [PRAIRIE],
					quadrants: [{x: 1, y: 1}, {x: 0, y: 1}],
				},
				rooms: [
					{
						type: ROOM_GRAVEYARD,
					},
					{
						type: ROOM_RAILROAD_STATION,
					}
				],
			},
			{
				name: 'Oxwood',
				layout: POI_LAYOUT_SCATTERED,
				railroad: {
					stopId: 2,
					fromId: 1,
					toId: 3,
				},
				criteria: {
					river: false,
					biomes: [TUNDRA],
					quadrants: [{x: 2, y: 0}, {x: 3, y: 0}],
				},
				rooms: [
					{
						type: ROOM_GRAVEYARD,
					},
					{
						type: ROOM_RAILROAD_STATION,
					}
				],
			},
			{
				name: 'Glumtrails',
				layout: POI_LAYOUT_SCATTERED,
				railroad: {
					stopId: 4,
					fromId: 3,
					toId: 5,
				},
				criteria: {
					river: false,
					biomes: [SWAMP],
					quadrants: [{x: 3, y: 2}, {x: 2, y: 2}],
				},
				rooms: [
					{
						type: ROOM_GRAVEYARD,
					},
					{
						type: ROOM_RAILROAD_STATION,
					}
				],
			},
			{
				name: 'Stagstone',
				layout: POI_LAYOUT_SCATTERED,
				railroad: {
					stopId: 1,
					fromId: 0,
					toId: 2,
				},
				criteria: {
					river: false,
					biomes: [FOREST],
					quadrants: [{x: 0, y: 0}, {x: 1, y: 0}, {x: 0, y: 1}],
				},
				rooms: [
					{
						type: ROOM_GRAVEYARD,
					},
					{
						type: ROOM_RAILROAD_STATION,
					}
				],
			},
			{
				name: 'Skinny Snag',
				layout: POI_LAYOUT_SCATTERED,
				railroad: {
					stopId: 5,
					fromId: 4,
					toId: 0,
				},
				criteria: {
					river: false,
					biomes: [DESERT],
					quadrants: [{x: 0, y: 2}, {x: 1, y: 2}],
				},
				rooms: [
					{
						type: ROOM_GRAVEYARD,
					},
					{
						type: ROOM_RAILROAD_STATION,
					}
				],
			},
			{
				name: 'Fort Mills',
				layout: POI_LAYOUT_SCATTERED,
				railroad: {
					stopId: 3,
					fromId: 2,
					toId: 4,
				},
				criteria: {
					river: false,
					biomes: [FOREST],
					quadrants: [{x: 3, y: 1}],
				},
				rooms: [
					{
						type: ROOM_GRAVEYARD,
					},
					{
						type: ROOM_RAILROAD_STATION,
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
			if (z.template.railroad != null)
			{
				railroad.addStop({
					stopId: z.template.railroad.stopId,
					zoneId: z.zoneId,
					fromId: z.template.railroad.fromId,
					toId: z.template.railroad.toId,
				});
			}
		}

		railroad.generate();
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

		if (world.zones.zones.isOnEdge(pos.x, pos.y))
		{
			return null;
		}

		var quadrant = pos.divide(16).floor();
		var zone = world.zones.getZone(pos);

		if (!criteria.quadrants.exists((q) -> q.equals(quadrant)))
		{
			return null;
		}

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
