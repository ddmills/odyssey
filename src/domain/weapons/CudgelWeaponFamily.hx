package domain.weapons;

import domain.components.Weapon;
import domain.skills.Skills;
import ecs.Entity;
import hxd.Rand;

class CudgelWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = false;
		skill = SKILL_CUDGEL;
	}
}
