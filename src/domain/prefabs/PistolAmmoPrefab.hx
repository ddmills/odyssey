package domain.prefabs;

import data.ColorKey;
import domain.components.Ammo;
import domain.components.Destructable;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stackable;
import ecs.Entity;

class PistolAmmoPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(CARTON, C_PINK_1, C_WHITE_1, OBJECTS));
		entity.add(new Moniker('Ammo, pistol'));
		entity.add(new Loot());
		entity.add(new Stackable(STACK_AMMO_PISTOL, 100));
		entity.add(new Ammo(AMMO_PISTOL));
		entity.add(new Destructable());

		return entity;
	}
}
