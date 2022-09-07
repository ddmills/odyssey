package domain.events;

import domain.weapons.Attack;
import ecs.EntityEvent;

class AttackedEvent extends EntityEvent
{
	public var attack:Attack;
	public var isHit:Bool;

	public function new(attack:Attack)
	{
		this.attack = attack;
		this.isHit = false;
	}
}
