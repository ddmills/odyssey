package domain.weapons;

import data.domain.DamageType;
import ecs.Entity;

typedef Attack =
{
	attacker:Entity,
	toHit:Int,
	damage:Int,
	damageType:DamageType,
	isCritical:Bool,
	defender:Null<Entity>,
}
