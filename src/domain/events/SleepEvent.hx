package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class SleepEvent extends EntityEvent
{
	public var sleepable:Entity;

	public function new(sleepable:Entity)
	{
		this.sleepable = sleepable;
	}
}
