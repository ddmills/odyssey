package domain.terrain.gen.railroad;

import common.algorithm.AStar;
import common.algorithm.Distance;
import common.rand.Perlin;
import core.Game;

typedef RailroadStop =
{
	stopId:Int,
	zoneId:Int,
	fromId:Int,
	toId:Int
};

class RailroadData
{
	public var stops:Array<RailroadStop>;

	public function new()
	{
		stops = [];
	}

	public function addStop(stop:RailroadStop)
	{
		stops.push(stop);
	}

	public function generate()
	{
		var perlin = new Perlin(15);
		var zones = Game.instance.world.zones;

		for (stop in stops)
		{
			var endStop = stops.find((s) -> s.stopId == stop.toId);
			var startZone = zones.getZoneById(stop.zoneId);
			var endZone = zones.getZoneById(endStop.zoneId);

			var astar = AStar.GetPath({
				start: startZone.zonePos,
				goal: endZone.zonePos,
				allowDiagonals: false,
				cost: (a, b) ->
				{
					if (zones.isOutOfBounds(b))
					{
						return Math.POSITIVE_INFINITY;
					}

					var zone = zones.getZone(b);

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
					zone.railroad.lineId.push(stop.stopId);
				}
				else
				{
					zone.railroad = {
						lineId: [stop.stopId],
					};
				}
			}
		}
	}
}
