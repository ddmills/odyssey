package domain.weapons;

import ecs.Entity;

typedef Attack =
{
	attacker:Entity,
	toHit:Int,
	damage:Int,
	isCritical:Bool,
}
