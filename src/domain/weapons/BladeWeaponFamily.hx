package domain.weapons;

class BladeWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = false;
		stat = STAT_BLADE;
	}
}
