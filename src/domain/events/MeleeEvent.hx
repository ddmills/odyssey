package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class MeleeEvent extends EntityEvent
{
	public var defender:Entity;
	public var attacker:Entity;
	public var isHandled:Bool;

	public function new(defender:Entity, attacker:Entity)
	{
		this.defender = defender;
		this.attacker = attacker;
		this.isHandled = false;
	}
}
