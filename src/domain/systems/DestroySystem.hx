package domain.systems;

import core.Frame;
import domain.components.IsDestroyed;
import ecs.Query;
import ecs.System;

class DestroySystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [IsDestroyed]
		});
	}

	override function update(frame:Frame)
	{
		for (entity in query)
		{
			var destroying = entity.get(IsDestroyed);

			if (destroying.pass > 0)
			{
				entity.destroy();
			}
			else
			{
				destroying.pass++;
			}
		}
	}
}
