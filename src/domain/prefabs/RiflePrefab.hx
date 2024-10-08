package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Destructable;
import domain.components.Equipment;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Weapon;
import ecs.Entity;

class RiflePrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var entity = new Entity(pos);
		entity.add(new Sprite(RIFLE, C_BLUE, C_WOOD, OBJECTS));
		entity.add(new Moniker('Rifle'));
		entity.add(new Loot());
		entity.add(new Destructable());
		entity.add(new Equipment([EQ_SLOT_HAND]));
		entity.get(Equipment).extraSlotTypes = [EQ_SLOT_HAND];
		entity.get(Equipment).equipAudio = GUN_HANDLE_1;
		entity.get(Equipment).unequipAudio = GUN_HANDLE_4;

		var weapon = new Weapon(WPN_FAMILY_RIFLE);

		weapon.accuracy = 3;
		weapon.modifier = 5;
		weapon.baseCost = 110;
		weapon.ammo = 1;
		weapon.ammoCapacity = 1;
		weapon.range = 14;
		weapon.reloadAudio = RELOAD_CLIP_3;
		weapon.unloadAudio = UNLOAD_CLIP_3;
		entity.add(weapon);

		return entity;
	}
}
