package domain.systems;

import core.Frame;
import domain.components.Crushable.Cruashable;
import domain.components.IsCreature;
import domain.components.IsPlayer;
import ecs.Query;
import ecs.System;

class CrushSystem extends System
{
	var crushables:Query;

	public function new()
	{
		crushables = new Query({
			all: [Cruashable],
		});
	}

	public override function update(frame:Frame)
	{
		if (world.clock.tickDelta <= 0)
		{
			return;
		}

		for (entity in crushables)
		{
			var others = world.getEntitiesAt(entity.pos.toIntPoint());

			var isCrushed = others.exists((e) ->
			{
				if (e.id == entity.id)
				{
					return false;
				}

				return e.has(IsCreature) || e.has(IsPlayer);
			});

			if (isCrushed)
			{
				var crushable = entity.get(Cruashable);
				crushable.onCrushed();
			}
		}
	}
}
