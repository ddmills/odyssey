package domain.weapons;

class ShotgunWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = true;
		skill = SKILL_SHOTGUN;
	}
}
