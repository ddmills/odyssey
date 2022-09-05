package domain.events;

import common.struct.Coordinate;
import ecs.Entity;
import ecs.EntityEvent;

class TryDropEvent extends EntityEvent
{
	public var dropper(default, null):Entity;
	public var pos(default, null):Coordinate;

	public function new(dropper:Entity, pos:Coordinate = null)
	{
		this.dropper = dropper;
		this.pos = pos;
	}
}
