package domain.weapons;

import data.SoundResources;
import hxd.Rand;
import hxd.res.Sound;

class PistolWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = true;
		skill = SKILL_PISTOL;
		ammo = AMMO_PISTOL;
	}

	public override function getSound():Sound
	{
		return Rand.create().pick([SoundResources.SHOT_PISTOL_1, SoundResources.SHOT_PISTOL_2]);
	}
}
