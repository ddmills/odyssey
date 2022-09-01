package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

typedef EntityInteraction =
{
	name:String,
	evt:EntityEvent,
}

class GetInteractionsEvent extends EntityEvent
{
	public var interactor(default, null):Entity;
	public var interactions(default, null):Array<EntityInteraction>;

	public function new(interactor:Entity)
	{
		super(EVT_GET_INTERACTIONS);
		this.interactor = interactor;
		interactions = new Array();
	}
}
