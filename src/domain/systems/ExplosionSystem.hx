package domain.systems;

import core.Frame;
import domain.components.Explosive;
import domain.components.IsDestroyed;
import ecs.Query;
import ecs.System;

class ExplosionSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [Explosive],
			none: [IsDestroyed],
		});
	}

	override function update(frame:Frame)
	{
		var tickDelta = world.clock.tickDelta;

		if (tickDelta <= 0)
		{
			return;
		}

		for (entity in query)
		{
			var explosive = entity.get(Explosive);

			explosive.onTickDelta(tickDelta);
		}
	}
}
