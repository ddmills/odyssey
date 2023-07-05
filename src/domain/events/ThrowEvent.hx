package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class ThrowEvent extends EntityEvent
{
	public var thrower:Entity;

	public function new(thrower:Entity)
	{
		this.thrower = thrower;
	}
}
