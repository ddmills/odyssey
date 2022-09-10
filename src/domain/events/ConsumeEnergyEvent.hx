package domain.events;

import ecs.EntityEvent;

class ConsumeEnergyEvent extends EntityEvent
{
	public var value:Int;

	public function new(value:Int)
	{
		this.value = value;
	}
}
