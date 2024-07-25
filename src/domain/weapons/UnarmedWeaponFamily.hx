package domain.weapons;

class UnarmedWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = false;
		stat = STAT_UNARMED;
	}
}
