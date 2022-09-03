package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class TakeEvent extends EntityEvent
{
	public var taker(default, null):Entity;

	public function new(taker:Entity)
	{
		this.taker = taker;
	}
}
