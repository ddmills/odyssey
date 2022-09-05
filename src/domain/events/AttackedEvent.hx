package domain.events;

import domain.weapons.Attack;
import ecs.EntityEvent;

class AttackedEvent extends EntityEvent
{
	public var attack:Attack;

	public function new(attack:Attack)
	{
		this.attack = attack;
	}
}
