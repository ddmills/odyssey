package domain.weapons;

import data.WeaponFamilyType;

class Weapons
{
	private var families:Map<WeaponFamilyType, WeaponFamily> = new Map();

	public function new() {}

	public function initialize()
	{
		families.set(WPN_FAMILY_PISTOL, new PistolWeaponFamily());
		families.set(WPN_FAMILY_CUDGEL, new CudgelWeaponFamily());
		families.set(WPN_FAMILY_RIFLE, new RifleWeaponFamily());
		families.set(WPN_FAMILY_UNARMED, new UnarmedWeaponFamily());
	}
}
