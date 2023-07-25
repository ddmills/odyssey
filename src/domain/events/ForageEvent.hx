package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class ForageEvent extends EntityEvent
{
	public var forager:Entity;

	public function new(forager:Entity)
	{
		this.forager = forager;
	}
}
