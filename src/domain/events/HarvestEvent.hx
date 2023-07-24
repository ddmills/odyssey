package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class HarvestEvent extends EntityEvent
{
	public var harvester:Entity;

	public function new(harvester:Entity)
	{
		this.harvester = harvester;
	}
}
