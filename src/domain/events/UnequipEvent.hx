package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class UnequipEvent extends EntityEvent
{
	public var unequipper:Entity;

	public function new(unequipper:Entity)
	{
		this.unequipper = unequipper;
	}
}
