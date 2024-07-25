package domain.weapons;

import data.AudioKey;
import hxd.Rand;

class PistolWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = true;
		stat = STAT_PISTOL;
		ammo = AMMO_PISTOL;
	}

	public override function getSound():AudioKey
	{
		return Rand.create().pick([SHOT_PISTOL_1, SHOT_PISTOL_2]);
	}
}
