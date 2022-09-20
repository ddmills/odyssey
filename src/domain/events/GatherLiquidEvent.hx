package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class GatherLiquidEvent extends EntityEvent
{
	public var gatherer:Entity;

	public function new(gatherer:Entity)
	{
		this.gatherer = gatherer;
	}
}
