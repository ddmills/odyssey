package domain.systems;

import core.Frame;
import domain.components.Health;
import domain.components.IsDead;
import domain.components.IsInventoried;
import domain.components.IsPlayer;
import domain.prefabs.Spawner;
import ecs.Entity;
import ecs.Query;
import ecs.System;
import screens.death.DeathScreen;

class DeathSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [IsDead],
			none: [IsInventoried],
		});
	}

	override function update(frame:Frame)
	{
		query.each((e:Entity) ->
		{
			if (e.has(Health))
			{
				var health = e.get(Health);
				if (health.corpsePrefab != null)
				{
					Spawner.Spawn(health.corpsePrefab, e.pos);
				}
			}
			if (e.has(IsPlayer))
			{
				game.screens.push(new DeathScreen());
			}
			else
			{
				e.destroy();
			}
		});
	}
}
