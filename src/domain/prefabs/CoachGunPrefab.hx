package domain.prefabs;

import data.AudioResources;
import data.ColorKey;
import data.TileResources;
import domain.components.Destructable;
import domain.components.Equipment;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Weapon;
import ecs.Entity;

class CoachGunPrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var entity = new Entity();
		entity.add(new Sprite(SHOTGUN_1, C_BLUE_1, C_RED_2, OBJECTS));
		entity.add(new Moniker('Coach gun'));
		entity.add(new Loot());
		entity.add(new Destructable());
		entity.add(new Equipment([EQ_SLOT_HAND], [EQ_SLOT_HAND]));
		entity.get(Equipment).equipAudio = GUN_HANDLE_1;
		entity.get(Equipment).unequipAudio = GUN_HANDLE_4;

		var weapon = new Weapon(WPN_FAMILY_SHOTGUN);
		weapon.accuracy = -2;
		weapon.modifier = 5;
		weapon.baseCost = 80;
		weapon.ammo = 3;
		weapon.ammoCapacity = 3;
		weapon.range = 6;
		weapon.reloadAudio = RELOAD_CLIP_1;
		weapon.unloadAudio = UNLOAD_CLIP_1;
		entity.add(weapon);

		return entity;
	}
}
