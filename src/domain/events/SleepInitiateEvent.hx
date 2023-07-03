package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class SleepInitiateEvent extends EntityEvent
{
	public var sleeper:Entity;

	public function new(sleeper:Entity)
	{
		this.sleeper = sleeper;
	}
}
