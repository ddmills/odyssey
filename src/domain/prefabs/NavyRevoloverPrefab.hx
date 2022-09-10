package domain.prefabs;

import data.SoundResources;
import data.TileResources;
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
		entity.add(new Sprite(TileResources.NAVY_REVOLVER, 0xA5CACA, 0x885B07, OBJECTS));
		entity.add(new Moniker('Navy revolover'));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_HAND, EQ_SLOT_HOLSTER]));
		entity.get(Equipment).equipSound = SoundResources.GUN_HANDLE_1;
		entity.get(Equipment).unequipSound = SoundResources.GUN_HANDLE_4;

		var weapon = new Weapon(WPN_FAMILY_PISTOL);
		weapon.baseCost = 60;
		weapon.ammo = 6;
		weapon.ammoCapacity = 6;
		weapon.range = 8;
		entity.add(weapon);

		return entity;
	}
}
