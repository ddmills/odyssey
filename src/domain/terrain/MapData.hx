package domain.terrain;

import common.rand.PoissonDiscSampler;
import common.struct.Grid;
import common.struct.IntPoint;
import core.Game;
import data.BiomeMap;
import data.BiomeType;
import data.ColorKey;
import data.PoiLayoutType;
import data.PoiType;
import data.RoomType;
import data.TileKey;
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

class MapData
{
	private var world(get, never):World;
	private var seed(get, never):Int;
	private var r:Rand;
	private var pois:Grid<Null<ZonePoi>>;
	private var railroad:RailroadData;
	private var biomes:Biomes;

	public function new()
	{
		biomes = new Biomes();
		pois = new Grid();
		railroad = new RailroadData();
	}

	public function initialize()
	{
		biomes.initialize(seed);
	}

	function addPois(size:PoiSize, dist:Int)
	{
		var pz = new PoissonDiscSampler(world.zoneCountX, world.zoneCountY, dist + 1, seed);
		var point = pz.sample();

		while (point != null)
		{
			if (!pois.isOnEdge(point.x, point.y))
			{
				var zone = world.zones.getZone(point);

				if (zone.hasRiver())
				{
					point = pz.sample();
					continue;
				}

				var biome = Biomes.get(zone.primaryBiome);

				if (checkPoiRange(point, dist))
				{
					var poi = biome.getPoi(size, r);

					if (poi.isNull())
					{
						return;
					}

					pois.set(point.x, point.y, new ZonePoi(zone.zoneId, poi));
				}
			}

			point = pz.sample();
		}
	}

	private function checkPoiRange(point:IntPoint, range:Int):Bool
	{
		for (dx in -range...(range + 1))
		{
			for (dy in -range...(range + 1))
			{
				var cur = pois.get(point.x + dx, point.y + dy);

				trace('check $dx,$dy, $range');

				if (cur != null)
				{
					return false;
				}
			}
		}

		return true;
	}

	public function generate()
	{
		r = new Rand(seed);

		pois = new Grid(world.zoneCountX, world.zoneCountY);
		railroad.stops = [];
		railroad.lines = [];

		var oxwood = new ZonePoi(world.zones.getZoneId({x: 55, y: 11}), {
			name: "Oxwood",
			type: PoiType.POI_TOWN,
			layout: PoiLayoutType.POI_LAYOUT_SCATTERED,
			size: POI_SZ_PRIMARY,
			rooms: [],
			icon: {
				primary: ColorKey.C_PURPLE,
				secondary: ColorKey.C_YELLOW,
				background: ColorKey.C_PURPLE,
				tileKey: TileKey.OVERWORLD_TOWN,
			}
		});

		pois.set(55, 11, oxwood);

		var esperloosa = new ZonePoi(world.zones.getZoneId({x: 22, y: 37}), {
			name: "Esperloosa",
			type: PoiType.POI_TOWN,
			layout: PoiLayoutType.POI_LAYOUT_SCATTERED,
			size: POI_SZ_PRIMARY,
			rooms: [],
			icon: {
				primary: ColorKey.C_PURPLE,
				secondary: ColorKey.C_GREEN,
				background: ColorKey.C_PURPLE,
				tileKey: TileKey.OVERWORLD_TOWN,
			}
		});

		pois.set(22, 37, esperloosa);

		addPois(POI_SZ_MAJOR, 7);
		addPois(POI_SZ_MEDIUM, 3);
		addPois(POI_SZ_MINOR, 1);

		// for (z in world.zones.zones)
		// {
		// 	z.value.railroad = null;
		// }

		// r = new Rand(seed);

		// var poiTemplates:Array<PoiTemplate> = [
		// 	{
		// 		name: 'Esperloosa',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_SCATTERED,
		// 		railroadStop: 0,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [PRAIRIE],
		// 			quadrants: [{x: 1, y: 1}, {x: 0, y: 1}],
		// 		},
		// 		rooms: [
		// 			{
		// 				type: ROOM_GRAVEYARD,
		// 			},
		// 			{
		// 				type: ROOM_GROVE_OAK,
		// 			},
		// 			{
		// 				type: ROOM_RAILROAD_STATION,
		// 			},
		// 			{
		// 				type: ROOM_CHURCH,
		// 			}
		// 		],
		// 	},
		// 	{
		// 		name: 'Dresbach',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_SCATTERED,
		// 		railroadStop: null,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [PRAIRIE],
		// 			quadrants: [{x: 1, y: 1}, {x: 0, y: 1}],
		// 		},
		// 		rooms: [
		// 			{
		// 				type: ROOM_GROVE_OAK,
		// 			},
		// 			{
		// 				type: ROOM_GRAVEYARD,
		// 			},
		// 			{
		// 				type: ROOM_CHURCH,
		// 			}
		// 		],
		// 	},
		// 	{
		// 		name: 'Oxwood',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_SCATTERED,
		// 		railroadStop: 2,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [TUNDRA],
		// 			quadrants: [{x: 2, y: 0}, {x: 3, y: 0}],
		// 		},
		// 		rooms: [
		// 			{
		// 				type: ROOM_GRAVEYARD,
		// 			},
		// 			{
		// 				type: ROOM_RAILROAD_STATION,
		// 			},
		// 			{
		// 				type: ROOM_CHURCH,
		// 			}
		// 		],
		// 	},
		// 	{
		// 		name: 'Glumtrails',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_SCATTERED,
		// 		railroadStop: 4,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [SWAMP],
		// 			quadrants: [{x: 3, y: 2}, {x: 2, y: 2}],
		// 		},
		// 		rooms: [
		// 			{
		// 				type: ROOM_GRAVEYARD,
		// 			},
		// 			{
		// 				type: ROOM_RAILROAD_STATION,
		// 			},
		// 			{
		// 				type: ROOM_CHURCH,
		// 			}
		// 		],
		// 	},
		// 	{
		// 		name: 'Stagstone',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_SCATTERED,
		// 		railroadStop: 1,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [FOREST],
		// 			quadrants: [{x: 0, y: 0}, {x: 1, y: 0}, {x: 0, y: 1}],
		// 		},
		// 		rooms: [
		// 			{
		// 				type: ROOM_GROVE_PINE,
		// 			},
		// 			{
		// 				type: ROOM_GRAVEYARD,
		// 			},
		// 			{
		// 				type: ROOM_RAILROAD_STATION,
		// 			}
		// 		],
		// 	},
		// 	{
		// 		name: 'Skinny Snag',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_FORTRESS,
		// 		railroadStop: 5,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [DESERT],
		// 			quadrants: [{x: 0, y: 2}, {x: 1, y: 2}],
		// 		},
		// 		rooms: [
		// 			// {
		// 			// 	type: ROOM_GRAVEYARD,
		// 			// },
		// 			// {
		// 			// 	type: ROOM_RAILROAD_STATION,
		// 			// }
		// 		],
		// 	},
		// 	{
		// 		name: 'Fort Mills',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_FORTRESS,
		// 		railroadStop: 3,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [FOREST],
		// 			quadrants: [{x: 3, y: 1}],
		// 		},
		// 		rooms: [
		// 			// {
		// 			// 	type: ROOM_GRAVEYARD,
		// 			// },
		// 			// {
		// 			// 	type: ROOM_GROVE_PINE,
		// 			// },
		// 			// {
		// 			// 	type: ROOM_RAILROAD_STATION,
		// 			// }
		// 		],
		// 	}
		// ];

		// var poisson = new PoissonDiscSampler(world.zoneCountX, world.zoneCountY, 4, seed);
		// var candidates = poisson.all();
		// var selected:Array<{template:PoiTemplate, zoneId:Int}> = [];

		// while (poiTemplates.length > 0 && candidates.length > 0)
		// {
		// 	var c = r.pickIdx(candidates);
		// 	var pos = candidates[c];
		// 	candidates.splice(c, 1);

		// 	for (template in poiTemplates)
		// 	{
		// 		var zone = matchZone(pos, template.criteria);

		// 		if (zone == null)
		// 		{
		// 			continue;
		// 		}

		// 		poiTemplates.remove(template);
		// 		selected.push({
		// 			template: template,
		// 			zoneId: zone.zoneId,
		// 		});

		// 		break;
		// 	}
		// }

		// for (z in selected)
		// {
		// 	if (z.template.railroadStop != null)
		// 	{
		// 		tryAddingStop(z.zoneId, z.template.railroadStop, r);
		// 		z.template.railroadStop = null;
		// 	}

		// 	pois.push(new ZonePoi(z.zoneId, z.template));
		// }

		// var lineId = 0;

		// railroad.addLine({
		// 	lineId: lineId++,
		// 	stopAId: 0,
		// 	stopBId: 1,
		// });

		// railroad.addLine({
		// 	lineId: lineId++,
		// 	stopAId: 1,
		// 	stopBId: 2,
		// });

		// railroad.addLine({
		// 	lineId: lineId++,
		// 	stopAId: 2,
		// 	stopBId: 3,
		// });

		// railroad.addLine({
		// 	lineId: lineId++,
		// 	stopAId: 3,
		// 	stopBId: 4,
		// });

		// railroad.addLine({
		// 	lineId: lineId++,
		// 	stopAId: 4,
		// 	stopBId: 5,
		// });

		// railroad.addLine({
		// 	lineId: lineId++,
		// 	stopAId: 5,
		// 	stopBId: 0,
		// });

		// railroad.generate();		// for (z in world.zones.zones)
		// {
		// 	z.value.railroad = null;
		// }

		// r = new Rand(seed);

		// var poiTemplates:Array<PoiTemplate> = [
		// 	{
		// 		name: 'Esperloosa',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_SCATTERED,
		// 		railroadStop: 0,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [PRAIRIE],
		// 			quadrants: [{x: 1, y: 1}, {x: 0, y: 1}],
		// 		},
		// 		rooms: [
		// 			{
		// 				type: ROOM_GRAVEYARD,
		// 			},
		// 			{
		// 				type: ROOM_GROVE_OAK,
		// 			},
		// 			{
		// 				type: ROOM_RAILROAD_STATION,
		// 			},
		// 			{
		// 				type: ROOM_CHURCH,
		// 			}
		// 		],
		// 	},
		// 	{
		// 		name: 'Dresbach',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_SCATTERED,
		// 		railroadStop: null,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [PRAIRIE],
		// 			quadrants: [{x: 1, y: 1}, {x: 0, y: 1}],
		// 		},
		// 		rooms: [
		// 			{
		// 				type: ROOM_GROVE_OAK,
		// 			},
		// 			{
		// 				type: ROOM_GRAVEYARD,
		// 			},
		// 			{
		// 				type: ROOM_CHURCH,
		// 			}
		// 		],
		// 	},
		// 	{
		// 		name: 'Oxwood',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_SCATTERED,
		// 		railroadStop: 2,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [TUNDRA],
		// 			quadrants: [{x: 2, y: 0}, {x: 3, y: 0}],
		// 		},
		// 		rooms: [
		// 			{
		// 				type: ROOM_GRAVEYARD,
		// 			},
		// 			{
		// 				type: ROOM_RAILROAD_STATION,
		// 			},
		// 			{
		// 				type: ROOM_CHURCH,
		// 			}
		// 		],
		// 	},
		// 	{
		// 		name: 'Glumtrails',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_SCATTERED,
		// 		railroadStop: 4,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [SWAMP],
		// 			quadrants: [{x: 3, y: 2}, {x: 2, y: 2}],
		// 		},
		// 		rooms: [
		// 			{
		// 				type: ROOM_GRAVEYARD,
		// 			},
		// 			{
		// 				type: ROOM_RAILROAD_STATION,
		// 			},
		// 			{
		// 				type: ROOM_CHURCH,
		// 			}
		// 		],
		// 	},
		// 	{
		// 		name: 'Stagstone',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_SCATTERED,
		// 		railroadStop: 1,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [FOREST],
		// 			quadrants: [{x: 0, y: 0}, {x: 1, y: 0}, {x: 0, y: 1}],
		// 		},
		// 		rooms: [
		// 			{
		// 				type: ROOM_GROVE_PINE,
		// 			},
		// 			{
		// 				type: ROOM_GRAVEYARD,
		// 			},
		// 			{
		// 				type: ROOM_RAILROAD_STATION,
		// 			}
		// 		],
		// 	},
		// 	{
		// 		name: 'Skinny Snag',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_FORTRESS,
		// 		railroadStop: 5,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [DESERT],
		// 			quadrants: [{x: 0, y: 2}, {x: 1, y: 2}],
		// 		},
		// 		rooms: [
		// 			// {
		// 			// 	type: ROOM_GRAVEYARD,
		// 			// },
		// 			// {
		// 			// 	type: ROOM_RAILROAD_STATION,
		// 			// }
		// 		],
		// 	},
		// 	{
		// 		name: 'Fort Mills',
		// 		type: POI_TOWN,
		// 		layout: POI_LAYOUT_FORTRESS,
		// 		railroadStop: 3,
		// 		criteria: {
		// 			river: false,
		// 			biomes: [FOREST],
		// 			quadrants: [{x: 3, y: 1}],
		// 		},
		// 		rooms: [
		// 			// {
		// 			// 	type: ROOM_GRAVEYARD,
		// 			// },
		// 			// {
		// 			// 	type: ROOM_GROVE_PINE,
		// 			// },
		// 			// {
		// 			// 	type: ROOM_RAILROAD_STATION,
		// 			// }
		// 		],
		// 	}
		// ];

		// var poisson = new PoissonDiscSampler(world.zoneCountX, world.zoneCountY, 4, seed);
		// var candidates = poisson.all();
		// var selected:Array<{template:PoiTemplate, zoneId:Int}> = [];

		// while (poiTemplates.length > 0 && candidates.length > 0)
		// {
		// 	var c = r.pickIdx(candidates);
		// 	var pos = candidates[c];
		// 	candidates.splice(c, 1);

		// 	for (template in poiTemplates)
		// 	{
		// 		var zone = matchZone(pos, template.criteria);

		// 		if (zone == null)
		// 		{
		// 			continue;
		// 		}

		// 		poiTemplates.remove(template);
		// 		selected.push({
		// 			template: template,
		// 			zoneId: zone.zoneId,
		// 		});

		// 		break;
		// 	}
		// }

		// for (z in selected)
		// {
		// 	if (z.template.railroadStop != null)
		// 	{
		// 		tryAddingStop(z.zoneId, z.template.railroadStop, r);
		// 		z.template.railroadStop = null;
		// 	}

		// 	pois.push(new ZonePoi(z.zoneId, z.template));
		// }

		// var lineId = 0;

		// railroad.addLine({
		// 	lineId: lineId++,
		// 	stopAId: 0,
		// 	stopBId: 1,
		// });

		// railroad.addLine({
		// 	lineId: lineId++,
		// 	stopAId: 1,
		// 	stopBId: 2,
		// });

		// railroad.addLine({
		// 	lineId: lineId++,
		// 	stopAId: 2,
		// 	stopBId: 3,
		// });

		// railroad.addLine({
		// 	lineId: lineId++,
		// 	stopAId: 3,
		// 	stopBId: 4,
		// });

		// railroad.addLine({
		// 	lineId: lineId++,
		// 	stopAId: 4,
		// 	stopBId: 5,
		// });

		// railroad.addLine({
		// 	lineId: lineId++,
		// 	stopAId: 5,
		// 	stopBId: 0,
		// });

		// railroad.generate();
	}

	public function getPOIForZone(zoneId:Int):ZonePoi
	{
		return pois.getAt(zoneId);
	}

	// function tryAddingStop(zoneId:Int, stopId:Int, r:Rand)
	// {
	// 	var zone = world.zones.getZoneById(zoneId);
	// 	var neighbors = world.zones.getImmediateNeighborZones(zone.zonePos);
	// 	r.shuffle(neighbors);
	// 	var open = neighbors.find((n) ->
	// 	{
	// 		return n.poi == null && !BiomeMap.HasRiver(n.biomes);
	// 	});
	// 	if (open == null)
	// 	{
	// 		return;
	// 	}
	// 	railroad.addStop({
	// 		stopId: stopId,
	// 		zoneId: open.zoneId,
	// 		parentZoneId: zoneId,
	// 	});
	// 	pois.push(new ZonePoi(open.zoneId, {
	// 		name: 'Railroad Station $stopId',
	// 		type: POI_RAILROAD_STATION,
	// 		layout: POI_LAYOUT_RAILROAD_STATION,
	// 		rooms: [
	// 			{
	// 				type: ROOM_RAILROAD_STATION,
	// 			}
	// 		],
	// 		criteria: null,
	// 		railroadStop: stopId,
	// 	}));
	// }

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

		if (criteria.river != BiomeMap.HasRiver(zone.biomes))
		{
			return null;
		}

		return zone;
	}

	public function save():SaveMap
	{
		return {
			pois: pois.save((p) -> p.save()),
			railroad: railroad.save(),
		};
	}

	public function load(data:SaveMap)
	{
		r = new Rand(world.seed);

		pois.load(data.pois, (z) -> ZonePoi.Load(z));
		railroad = RailroadData.Load(data.railroad);
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
