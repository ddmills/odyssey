package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class PourEvent extends EntityEvent
{
	public var pourer:Entity;

	public function new(pourer:Entity)
	{
		this.pourer = pourer;
	}
}
