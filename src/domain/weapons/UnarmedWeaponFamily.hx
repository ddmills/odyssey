package domain.weapons;

class UnarmedWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = false;
		skill = SKILL_UNARMED;
	}
}
