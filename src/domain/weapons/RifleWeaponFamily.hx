package domain.weapons;

import data.SoundResources;
import hxd.Rand;
import hxd.res.Sound;

class RifleWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = true;
		skill = SKILL_RIFLE;
		ammo = AMMO_RIFLE;
	}

	public override function getSound():Sound
	{
		return Rand.create().pick([SoundResources.SHOT_RIFLE_1]);
	}
}
