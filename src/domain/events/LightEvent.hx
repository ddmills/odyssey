package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class LightEvent extends EntityEvent
{
	public var lighter:Entity;

	public function new(lighter:Entity)
	{
		this.lighter = lighter;
	}
}
