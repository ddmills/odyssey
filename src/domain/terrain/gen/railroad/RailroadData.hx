package domain.terrain.gen.railroad;

import common.algorithm.AStar;
import common.rand.Perlin;
import core.Game;

typedef RailroadLine =
{
	lineId:Int,
	stopAId:Int,
	stopBId:Int,
};

typedef RailroadStop =
{
	stopId:Int,
	zoneId:Int,
	parentZoneId:Int,
};

class RailroadData
{
	public var stops:Array<RailroadStop>;
	public var lines:Array<RailroadLine>;

	public function new()
	{
		stops = [];
		lines = [];
	}

	public function addStop(stop:RailroadStop)
	{
		stops.push(stop);
		var zone = Game.instance.world.zones.getZoneById(stop.zoneId);
		zone.railroad = {
			lineIds: [],
			stopId: stop.stopId,
		};
	}

	public function addLine(line:RailroadLine)
	{
		lines.push(line);
	}

	public function getStop(stopId:Int):RailroadStop
	{
		return stops.find((s) -> s.stopId == stopId);
	}

	public function generate()
	{
		var perlin = new Perlin(15);
		var zones = Game.instance.world.zones;

		for (line in lines)
		{
			var stopA = getStop(line.stopAId);
			var stopB = getStop(line.stopBId);
			var zoneA = zones.getZoneById(stopA.zoneId);
			var zoneB = zones.getZoneById(stopB.zoneId);

			var astar = AStar.GetPath({
				start: zoneA.zonePos,
				goal: zoneB.zonePos,
				allowDiagonals: false,
				cost: (a, b) ->
				{
					if (zones.isOutOfBounds(b))
					{
						return Math.POSITIVE_INFINITY;
					}

					var zone = zones.getZone(b);

					if (zone.poi != null)
					{
						return Math.POSITIVE_INFINITY;
					}

					if (zone.railroad != null)
					{
						return .15;
					}

					if (zone.biomes.river != null)
					{
						return 1.5;
					}

					var weight = .5 + perlin.get(b, 80, 16);

					return weight;
				},
			});

			if (!astar.success)
			{
				trace('NO RAILROAD!');
				return;
			}

			for (part in astar.path)
			{
				var zone = zones.getZone(part);
				if (zone.railroad != null)
				{
					zone.railroad.lineIds.push(line.lineId);
				}
				else
				{
					zone.railroad = {
						lineIds: [line.lineId],
						stopId: null,
					};
				}
			}
		}
	}
}
