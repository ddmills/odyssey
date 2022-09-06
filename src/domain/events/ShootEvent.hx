package domain.events;

import common.struct.IntPoint;
import ecs.Entity;
import ecs.EntityEvent;

class ShootEvent extends EntityEvent
{
	public var target:IntPoint;
	public var attacker:Entity;
	public var isHandled:Bool;

	public function new(target:IntPoint, attacker:Entity)
	{
		this.target = target;
		this.attacker = attacker;
		this.isHandled = false;
	}
}
