package domain.weapons;

class BladeWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = false;
		skill = SKILL_BLADE;
	}
}
