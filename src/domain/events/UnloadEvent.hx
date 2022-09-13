package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class UnloadEvent extends EntityEvent
{
	public var unloader:Entity;

	public function new(unloader:Entity)
	{
		this.unloader = unloader;
	}
}
