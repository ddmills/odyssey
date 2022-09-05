package domain.weapons;

class PistolWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = true;
		skill = SKILL_PISTOL;
	}
}
