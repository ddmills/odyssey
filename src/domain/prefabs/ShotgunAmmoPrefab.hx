package domain.prefabs;

import data.ColorKey;
import domain.components.Ammo;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stackable;
import ecs.Entity;

class ShotgunAmmoPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(CARTON, C_YELLOW_2, C_WHITE_1, OBJECTS));
		entity.add(new Moniker('Ammo, shotgun'));
		entity.add(new Loot());
		entity.add(new Stackable(STACK_AMMO_SHOTGUN, 24));
		entity.add(new Ammo(AMMO_SHOTGUN));

		return entity;
	}
}
