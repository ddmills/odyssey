package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class OpenDoorEvent extends EntityEvent
{
	public var opener:Entity;

	public function new(opener:Entity)
	{
		this.opener = opener;
	}
}
