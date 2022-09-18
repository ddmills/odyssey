package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class ExtinguishEvent extends EntityEvent
{
	public var extinguisher:Entity;

	public function new(extinguisher:Entity)
	{
		this.extinguisher = extinguisher;
	}
}
