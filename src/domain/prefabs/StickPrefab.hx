package domain.prefabs;

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
	public function Create(?options:Dynamic)
	{
		var entity = new Entity();

		var sprite = new Sprite(STICK_1, 0x814B0D, 0x000000, OBJECTS);

		entity.add(sprite);
		entity.add(new Moniker('Stick'));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_HAND]));
		entity.add(new Weapon(WPN_FAMILY_CUDGEL));
		entity.add(new Stackable(STACK_STICK));
		entity.add(new Fuel(FUEL_WOOD, 50));

		return entity;
	}
}
