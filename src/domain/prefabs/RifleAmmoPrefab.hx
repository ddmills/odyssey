package domain.prefabs;

import data.ColorKeys;
import domain.components.Ammo;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stackable;
import ecs.Entity;

class RifleAmmoPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(CARTON, ColorKeys.C_GREEN_1, ColorKeys.C_WHITE_1, OBJECTS));
		entity.add(new Moniker('Ammo, rifle'));
		entity.add(new Loot());
		entity.add(new Stackable(STACK_AMMO_RIFLE, 24));
		entity.add(new Ammo(AMMO_RIFLE));

		return entity;
	}
}
