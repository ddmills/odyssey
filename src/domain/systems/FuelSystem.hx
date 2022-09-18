package domain.systems;

import core.Frame;
import domain.components.FuelConsumer;
import domain.components.IsDestroyed;
import ecs.Query;
import ecs.System;

class FuelSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [FuelConsumer],
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
			var consumer = entity.get(FuelConsumer);

			consumer.onTickDelta(tickDelta);
		}
	}
}
