package domain.weapons;

import data.AudioKey;
import data.AudioResources;
import hxd.Rand;
import hxd.res.Sound;

class ShotgunWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = true;
		skill = SKILL_SHOTGUN;
		ammo = AMMO_PISTOL;
	}

	public override function getSound():AudioKey
	{
		return Rand.create().pick([SHOT_SHOTGUN_1, SHOT_SHOTGUN_2, SHOT_SHOTGUN_3, SHOT_SHOTGUN_4,]);
	}
}
