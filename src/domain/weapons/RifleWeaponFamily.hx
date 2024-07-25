package domain.weapons;

import data.AudioKey;
import hxd.Rand;
import screens.target.footprints.Footprint;
import screens.target.footprints.LineFootprint;

class RifleWeaponFamily extends WeaponFamily
{
	public function new()
	{
		isRanged = true;
		stat = STAT_RIFLE;
		ammo = AMMO_RIFLE;
	}

	public override function getFootprint():Footprint
	{
		return new LineFootprint();
	}

	public override function getSound():AudioKey
	{
		return Rand.create().pick([SHOT_RIFLE_1]);
	}
}
