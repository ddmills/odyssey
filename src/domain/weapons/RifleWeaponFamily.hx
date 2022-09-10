package domain.weapons;

import data.AudioKey;
import data.AudioResources;
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

	public override function getSound():AudioKey
	{
		return Rand.create().pick([SHOT_RIFLE_1]);
	}
}
