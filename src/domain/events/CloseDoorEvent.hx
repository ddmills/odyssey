package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class CloseDoorEvent extends EntityEvent
{
	public var closer:Entity;

	public function new(closer:Entity)
	{
		this.closer = closer;
	}
}
