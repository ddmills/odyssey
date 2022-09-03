package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class StashEvent extends EntityEvent
{
	public var target(default, null):Entity;

	public function new(target:Entity)
	{
		this.target = target;
	}
}
