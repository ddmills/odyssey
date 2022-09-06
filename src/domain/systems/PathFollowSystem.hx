package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import domain.components.Move;
import domain.components.MoveComplete;
import domain.components.Path;
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
					var speed = .18;

					entity.add(new Move(target, speed, LINEAR));
				}
				else
				{
					entity.remove(path);
				}
			}
		}
	}
}
