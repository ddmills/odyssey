package domain.weapons;

import data.AudioKey;
import hxd.Rand;

class ShotgunWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = true;
		stat = STAT_SHOTGUN;
		ammo = AMMO_SHOTGUN;
	}

	public override function getSound():AudioKey
	{
		return Rand.create().pick([SHOT_SHOTGUN_1, SHOT_SHOTGUN_2, SHOT_SHOTGUN_3, SHOT_SHOTGUN_4,]);
	}
}
