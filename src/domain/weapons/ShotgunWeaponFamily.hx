package domain.weapons;

import data.AudioKey;
import hxd.Rand;
import screens.target.footprints.ConeFootprint;
import screens.target.footprints.Footprint;

class ShotgunWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = true;
		skill = SKILL_SHOTGUN;
		ammo = AMMO_SHOTGUN;
	}

	public override function getSound():AudioKey
	{
		return Rand.create().pick([SHOT_SHOTGUN_1, SHOT_SHOTGUN_2, SHOT_SHOTGUN_3, SHOT_SHOTGUN_4,]);
	}

	public override function getFootprint():Footprint
	{
		return new ConeFootprint(8, 60);
	}
}
