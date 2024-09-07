package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class UsePortalEvent extends EntityEvent
{
	public var user:Entity;

	public function new(user:Entity)
	{
		this.user = user;
	}
}
