package domain.systems;

import core.Frame;
import domain.components.Health;
import domain.components.HitBlink;
import domain.components.IsDead;
import domain.components.IsDestroyed;
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
			none: [IsInventoried, IsDestroyed],
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
					var corpse = Spawner.Spawn(health.corpsePrefab, e.pos);
					corpse.add(new HitBlink());
				}
			}
			if (e.has(IsPlayer))
			{
				game.screens.push(new DeathScreen());
			}
			else
			{
				e.add(new IsDestroyed());
			}
		});
	}
}
