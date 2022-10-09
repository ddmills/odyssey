package domain.terrain;

import common.rand.PoissonDiscSampler;
import common.struct.IntPoint;
import core.Game;
import data.BiomeType;
import data.PoiLayoutType;
import data.PoiType;
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
	lineId:Int,
	fromId:Int,
	toId:Int,
}

typedef PoiTemplate =
{
	name:String,
	type:PoiType,
	railroadStop:Null<Int>,
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
		railroad.stops = [];
		railroad.lines = [];
		for (z in world.zones.zones)
		{
			z.value.railroad = null;
		}

		// r = new Rand(seed);
		r = Rand.create();

		trace('seed', r.getSeed());

		var poiTemplates:Array<PoiTemplate> = [
			{
				name: 'Esperloosa',
				type: POI_TOWN,
				layout: POI_LAYOUT_SCATTERED,
				railroadStop: 0,
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
				type: POI_TOWN,
				layout: POI_LAYOUT_SCATTERED,
				railroadStop: 2,
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
				type: POI_TOWN,
				layout: POI_LAYOUT_SCATTERED,
				railroadStop: 4,
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
				type: POI_TOWN,
				layout: POI_LAYOUT_SCATTERED,
				railroadStop: 1,
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
				type: POI_TOWN,
				layout: POI_LAYOUT_SCATTERED,
				railroadStop: 5,
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
				type: POI_TOWN,
				layout: POI_LAYOUT_SCATTERED,
				railroadStop: 3,
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
			if (z.template.railroadStop != null)
			{
				tryAddingStop(z.zoneId, z.template.railroadStop, r);
				z.template.railroadStop = null;
			}

			pois.push(new ZonePoi(z.zoneId, z.template));
		}

		var lineId = 0;

		railroad.addLine({
			lineId: lineId++,
			stopAId: 0,
			stopBId: 1,
		});

		railroad.addLine({
			lineId: lineId++,
			stopAId: 1,
			stopBId: 2,
		});

		railroad.addLine({
			lineId: lineId++,
			stopAId: 2,
			stopBId: 3,
		});

		railroad.addLine({
			lineId: lineId++,
			stopAId: 3,
			stopBId: 4,
		});

		railroad.addLine({
			lineId: lineId++,
			stopAId: 4,
			stopBId: 5,
		});

		railroad.addLine({
			lineId: lineId++,
			stopAId: 5,
			stopBId: 0,
		});

		railroad.generate();
	}

	public function getPOIForZone(zoneId:Int):ZonePoi
	{
		return pois.find((t) -> t.zoneId == zoneId);
	}

	function tryAddingStop(zoneId:Int, stopId:Int, r:Rand)
	{
		var zone = world.zones.getZoneById(zoneId);
		var neighbors = world.zones.getImmediateNeighborZones(zone.zonePos);
		r.shuffle(neighbors);

		var open = neighbors.find((n) ->
		{
			return n.poi == null && n.biomes.river == null;
		});

		railroad.addStop({
			stopId: stopId,
			zoneId: open.zoneId,
			parentZoneId: zoneId,
		});

		pois.push(new ZonePoi(open.zoneId, {
			name: 'Railroad Station $stopId',
			type: POI_RAILROAD_STATION,
			layout: POI_LAYOUT_RAILROAD_STATION,
			rooms: [
				{
					type: ROOM_RAILROAD_STATION,
				}
			],
			criteria: null,
			railroadStop: stopId,
		}));
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
		return {
			pois: pois.map((p) -> p.save()),
			railroad: railroad.save(),
		};
	}

	public function load(data:SaveMap)
	{
		r = new Rand(world.seed);
		pois = data.pois.map((d) -> ZonePoi.Load(d));
		railroad = RailroadData.Load(data.railroad);
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
