package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Ammo;
import domain.components.Destructable;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stackable;
import ecs.Entity;

class RifleAmmoPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(CARTON, C_GREEN_1, C_YELLOW_0, OBJECTS));
		entity.add(new Moniker('Ammo, rifle'));
		entity.add(new Loot());
		entity.add(new Stackable(STACK_AMMO_RIFLE, 100));
		entity.add(new Ammo(AMMO_RIFLE));
		entity.add(new Destructable());

		return entity;
	}
}
