package domain.weapons;

import data.SoundResources;
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

	public override function getSound():Sound
	{
		return Rand.create().pick([
			SoundResources.SHOT_SHOTGUN_1,
			SoundResources.SHOT_SHOTGUN_2,
			SoundResources.SHOT_SHOTGUN_3,
			SoundResources.SHOT_SHOTGUN_4,
		]);
	}
}
