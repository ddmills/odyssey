package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Ammo;
import domain.components.Destructable;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stackable;
import ecs.Entity;

class ShotgunAmmoPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(CARTON, C_YELLOW_2, C_WHITE, OBJECTS));
		entity.add(new Moniker('Ammo, shotgun'));
		entity.add(new Loot());
		entity.add(new Stackable(STACK_AMMO_SHOTGUN, 100));
		entity.add(new Ammo(AMMO_SHOTGUN));
		entity.add(new Destructable());

		return entity;
	}
}
