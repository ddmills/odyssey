package domain.events;

import ecs.EntityEvent;

class DropEvent extends EntityEvent
{
	public function new()
	{
		super(EVT_DROP);
	}
}
