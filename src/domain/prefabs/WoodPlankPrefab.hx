package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Equipment;
import domain.components.Fuel;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Weapon;
import ecs.Entity;

class WoodPlankPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(PLANK, C_RED_3, C_BLACK, OBJECTS));
		entity.add(new Moniker('Wood plank'));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_HAND]));
		entity.add(new Weapon(WPN_FAMILY_CUDGEL));
		entity.add(new Fuel(FUEL_WOOD, 600));

		return entity;
	}
}
