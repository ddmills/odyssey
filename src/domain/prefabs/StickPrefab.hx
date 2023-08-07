package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Destructable;
import domain.components.Equipment;
import domain.components.Fuel;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stackable;
import domain.components.Weapon;
import ecs.Entity;

class StickPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(STICK, C_RED_3, C_BLACK, OBJECTS));
		entity.add(new Moniker('Stick'));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_HAND]));
		entity.add(new Weapon(WPN_FAMILY_CUDGEL));
		entity.add(new Stackable(STACK_STICK));
		entity.add(new Fuel(FUEL_WOOD, 200));
		entity.add(new Destructable());

		return entity;
	}
}
