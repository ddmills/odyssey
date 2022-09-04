package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

typedef EntityInteraction =
{
	name:String,
	evt:EntityEvent,
}

class QueryInteractionsEvent extends EntityEvent
{
	public var interactor(default, null):Entity;
	public var interactions(default, null):Array<EntityInteraction>;

	public function new(interactor:Entity)
	{
		this.interactor = interactor;
		interactions = new Array();
	}
}
