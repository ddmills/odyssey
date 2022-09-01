package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class PickupEvent extends EntityEvent
{
	public var interactor(default, null):Entity;

	public function new(interactor:Entity)
	{
		super(EVT_PICKUP);
		this.interactor = interactor;
	}
}
