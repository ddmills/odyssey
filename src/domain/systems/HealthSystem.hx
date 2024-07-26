package domain.systems;

import core.Frame;
import domain.components.Health;
import domain.components.IsDestroyed;
import ecs.Entity;
import ecs.Query;
import ecs.System;

class HealthSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [Health],
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

		query.each((e:Entity) ->
		{
			var health = e.get(Health);
			health.onTickDelta(tickDelta);
		});
	}
}
