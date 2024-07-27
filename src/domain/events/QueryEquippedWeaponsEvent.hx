package domain.events;

import domain.components.EquipmentSlot;
import domain.components.Weapon;
import domain.weapons.Weapons;
import ecs.EntityEvent;

typedef WeaponData =
{
	weapon:Weapon,
	slot:EquipmentSlot,
};

class QueryEquippedWeaponsEvent extends EntityEvent
{
	public var weapons:Array<WeaponData> = new Array();

	public function new() {}

	public inline function add(weapon:Weapon, slot:EquipmentSlot)
	{
		weapons.push({
			weapon: weapon,
			slot: slot,
		});
	}

	public function getPrimaryRanged()
	{
		return weapons.find((w) ->
		{
			if (!w.slot.isPrimary)
			{
				return false;
			}

			var family = Weapons.Get(w.weapon.family);

			return family.isRanged;
		});
	}
}
