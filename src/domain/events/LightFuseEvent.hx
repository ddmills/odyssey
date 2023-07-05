package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class LightFuseEvent extends EntityEvent
{
	public var lighter:Entity;

	public function new(lighter:Entity)
	{
		this.lighter = lighter;
	}
}
