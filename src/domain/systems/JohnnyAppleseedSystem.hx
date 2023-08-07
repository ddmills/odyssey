package domain.systems;

import core.Frame;
import domain.components.IsDestroyed;
import domain.components.IsDetached;
import domain.components.Moniker;
import ecs.Query;
import ecs.System;

class JohnnyAppleseedSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [IsDetached],
			none: [IsDestroyed],
		});
	}

	override function update(frame:Frame)
	{
		if (world.clock.tickDelta > 0)
		{
			for (e in query)
			{
				trace(e.get(Moniker).displayName);
			}
		}
	}
}
