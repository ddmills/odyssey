package domain.prefabs;

import domain.components.Equipment;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Weapon;
import ecs.Entity;

class NavyRevoloverPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var entity = new Entity();
		entity.add(new Sprite(NAVY_REVOLVER, 0xA5CACA, 0x814B0D, OBJECTS));
		entity.add(new Moniker('Navy revolover'));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_HAND, EQ_SLOT_HOLSTER]));
		entity.get(Equipment).equipAudio = GUN_HANDLE_1;
		entity.get(Equipment).unequipAudio = GUN_HANDLE_4;

		var weapon = new Weapon(WPN_FAMILY_PISTOL);
		weapon.baseCost = 60;
		weapon.ammo = 6;
		weapon.ammoCapacity = 6;
		weapon.range = 8;
		entity.add(weapon);

		return entity;
	}
}
