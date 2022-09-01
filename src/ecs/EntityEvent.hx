package ecs;

import domain.events.EntityEventType;

class EntityEvent
{
	public var type(default, null):EntityEventType;

	public function new(type:EntityEventType)
	{
		this.type = type;
	}

	public inline function is(type:EntityEventType):Bool
	{
		return this.type == type;
	}
}
