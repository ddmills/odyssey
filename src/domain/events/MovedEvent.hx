package domain.events;

import common.struct.Coordinate;
import ecs.Entity;
import ecs.EntityEvent;

class MovedEvent extends EntityEvent
{
	public var pos:Coordinate;
	public var mover:Entity;

	public function new(mover:Entity, pos:Coordinate)
	{
		this.mover = mover;
		this.pos = pos;
	}
}
