package domain.events;

import common.struct.IntPoint;
import ecs.EntityEvent;

class EntityReattachEvent extends EntityEvent
{
	public var worldPos:IntPoint;

	public function new(worldPos:IntPoint)
	{
		this.worldPos = worldPos;
	}
}
