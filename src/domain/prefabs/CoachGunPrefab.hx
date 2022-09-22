package domain.prefabs;

import data.AudioResources;
import data.ColorKeys;
import data.TileResources;
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
		entity.add(new Sprite(SHOTGUN_1, ColorKeys.C_BLUE_1, ColorKeys.C_RED_2, OBJECTS));
		entity.add(new Moniker('Coach gun'));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_HAND], [EQ_SLOT_HAND]));
		entity.get(Equipment).equipAudio = GUN_HANDLE_1;
		entity.get(Equipment).unequipAudio = GUN_HANDLE_4;

		var weapon = new Weapon(WPN_FAMILY_SHOTGUN);
		weapon.accuracy = -2;
		weapon.modifier = 5;
		weapon.baseCost = 80;
		weapon.ammo = 3;
		weapon.ammoCapacity = 3;
		weapon.range = 4;
		weapon.reloadAudio = RELOAD_CLIP_1;
		weapon.unloadAudio = UNLOAD_CLIP_1;
		entity.add(weapon);

		return entity;
	}
}
