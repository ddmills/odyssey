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
		entity.add(new Sprite(PISTOL_3, 0xA5CACA, 0x814B0D, OBJECTS));
		entity.add(new Moniker('Navy revolover'));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_HAND, EQ_SLOT_HOLSTER]));
		entity.get(Equipment).equipAudio = GUN_HANDLE_1;
		entity.get(Equipment).unequipAudio = GUN_HANDLE_4;

		var weapon = new Weapon(WPN_FAMILY_PISTOL);
		weapon.baseCost = 60;
		weapon.ammo = 5;
		weapon.ammoCapacity = 5;
		weapon.range = 5;
		weapon.reloadAudio = RELOAD_CLIP_5;
		weapon.unloadAudio = UNLOAD_CLIP_2;
		entity.add(weapon);

		return entity;
	}
}
