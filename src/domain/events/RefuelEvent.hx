package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class RefuelEvent extends EntityEvent
{
	public var refueler:Entity;

	public function new(refueler:Entity)
	{
		this.refueler = refueler;
	}
}
