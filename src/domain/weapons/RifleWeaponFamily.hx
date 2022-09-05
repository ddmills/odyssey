package domain.weapons;

class RifleWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = true;
		skill = SKILL_RIFLE;
	}
}
