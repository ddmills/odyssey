package domain.events;

import ecs.EntityEvent;

class EntityLoadedEvent extends EntityEvent
{
	public var tickDelta:Int;

	public function new(tickDelta:Int)
	{
		this.tickDelta = tickDelta;
	}
}
