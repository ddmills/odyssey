package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import domain.components.IsPlayer;
import domain.components.Move;
import domain.components.MoveComplete;
import domain.components.Moved;
import domain.components.Path;
import domain.events.ConsumeEnergyEvent;
import ecs.Query;
import ecs.System;

class PathFollowSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [Path]
		});
	}

	public override function update(frame:Frame)
	{
		for (entity in query)
		{
			var path = entity.get(Path);

			if (entity.has(MoveComplete) || !entity.has(Move))
			{
				if (path.hasNext())
				{
					var next = path.next();
					var target = new Coordinate(next.x, next.y, WORLD);
					var speed = .05;

					if (entity.has(IsPlayer))
					{
						var cost = EnergySystem.GetEnergyCost(entity, ACT_MOVE);
						entity.fireEvent(new ConsumeEnergyEvent(cost));
					}

					entity.add(new Move(target, speed, EASE_LINEAR));
				}
				else
				{
					entity.remove(path);
				}
			}
		}
	}
}
