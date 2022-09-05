package domain.weapons;

import data.WeaponFamilyType;

class Weapons
{
	private static var families:Map<WeaponFamilyType, WeaponFamily> = new Map();

	public static function Init()
	{
		families.set(WPN_FAMILY_PISTOL, new PistolWeaponFamily());
		families.set(WPN_FAMILY_RIFLE, new RifleWeaponFamily());
		families.set(WPN_FAMILY_SHOTGUN, new ShotgunWeaponFamily());
		families.set(WPN_FAMILY_UNARMED, new UnarmedWeaponFamily());
		families.set(WPN_FAMILY_CUDGEL, new CudgelWeaponFamily());
		families.set(WPN_FAMILY_BLADE, new BladeWeaponFamily());
	}

	public static function Get(family:WeaponFamilyType)
	{
		return families.get(family);
	}
}
