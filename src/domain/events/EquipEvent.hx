package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class EquipEvent extends EntityEvent
{
	public var equipper:Entity;

	public function new(equipper:Entity)
	{
		this.equipper = equipper;
	}
}
