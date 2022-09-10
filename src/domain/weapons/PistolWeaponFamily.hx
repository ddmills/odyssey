package domain.weapons;

import data.AudioKey;
import data.AudioResources;
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

	public override function getSound():AudioKey
	{
		return Rand.create().pick([SHOT_PISTOL_1, SHOT_PISTOL_2]);
	}
}
