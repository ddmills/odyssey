package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class EnemyKilledEvent extends EntityEvent
{
	public var enemy:Entity;

	public function new(enemy:Entity)
	{
		this.enemy = enemy;
	}
}
