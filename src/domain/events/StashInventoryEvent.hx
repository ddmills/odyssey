package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class StashInventoryEvent extends EntityEvent
{
	public var stasher(default, null):Entity;

	public function new(stasher:Entity)
	{
		this.stasher = stasher;
	}
}
