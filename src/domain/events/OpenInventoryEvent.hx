package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class OpenInventoryEvent extends EntityEvent
{
	public var opener(default, null):Entity;

	public function new(opener:Entity)
	{
		this.opener = opener;
	}
}
