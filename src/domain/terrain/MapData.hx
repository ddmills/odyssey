package domain.terrain;

import common.rand.PoissonDiscSampler;
import common.struct.Grid;
import common.struct.IntPoint;
import core.Game;
import data.BiomeMap;
import data.ColorKey;
import data.PoiLayoutType;
import data.PoiType;
import data.RoomType;
import data.TileKey;
import data.save.SaveWorld.SaveMap;
import domain.terrain.biomes.Biomes;
import domain.terrain.gen.RoomContent;
import domain.terrain.gen.ZonePoi;
import domain.terrain.gen.railroad.RailroadData;
import hxd.Rand;

typedef RoomTemplate =
{
	type:RoomType,
	?content:Array<RoomContent>,
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

		var oxwoodZoneId = world.zones.getZoneId({x: 55, y: 11});
		var esperloosaZoneId = world.zones.getZoneId({x: 22, y: 37});

		var esperPortal = world.portals.create({zoneId: esperloosaZoneId});
		var oxwoodPortal = world.portals.create({zoneId: oxwoodZoneId});

		esperPortal.destinationId = oxwoodPortal.id;
		oxwoodPortal.destinationId = esperPortal.id;

		var oxwood = new ZonePoi(oxwoodZoneId, {
			name: "Oxwood",
			type: PoiType.POI_TOWN,
			layout: PoiLayoutType.POI_LAYOUT_SCATTERED,
			size: POI_SZ_PRIMARY,
			rooms: [
				{
					type: ROOM_RAILROAD_STATION,
					content: [
						{
							spawnableType: LADDER_DOWN,
							spawnableSettings: {
								portalId: oxwoodPortal.id
							}
						}
					]
				}
			],
			icon: {
				primary: ColorKey.C_PURPLE,
				secondary: ColorKey.C_YELLOW,
				background: ColorKey.C_PURPLE,
				tileKey: TileKey.OVERWORLD_TOWN,
			}
		});

		pois.set(55, 11, oxwood);

		var esperloosa = new ZonePoi(esperloosaZoneId, {
			name: "Esperloosa",
			type: PoiType.POI_TOWN,
			layout: PoiLayoutType.POI_LAYOUT_SCATTERED,
			size: POI_SZ_PRIMARY,
			rooms: [
				{
					type: ROOM_RAILROAD_STATION,
					content: [
						{
							spawnableType: LADDER_DOWN,
							spawnableSettings: {
								portalId: esperPortal.id
							}
						}
					]
				}
			],
			icon: {
				primary: ColorKey.C_PURPLE,
				secondary: ColorKey.C_GREEN,
				background: ColorKey.C_PURPLE,
				tileKey: TileKey.OVERWORLD_TOWN,
			}
		});

		pois.set(22, 37, esperloosa);

		addPois(POI_SZ_MAJOR, 5);
		addPois(POI_SZ_MEDIUM, 3);
		addPois(POI_SZ_MINOR, 1);
	}

	public function getPOIForZone(zoneId:Int):ZonePoi
	{
		return pois.getAt(zoneId);
	}

	public function save():SaveMap
	{
		return {
			pois: pois.save((p) -> p?.save()),
			railroad: railroad.save(),
		};
	}

	public function load(data:SaveMap)
	{
		r = new Rand(world.seed);

		pois.load(data.pois, (z) -> z == null ? null : ZonePoi.Load(z));
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
