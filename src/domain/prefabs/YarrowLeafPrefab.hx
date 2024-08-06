package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Destructable;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stackable;
import ecs.Entity;

class YarrowLeafPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var quantity:Int = options.quantity == null ? 1 : options.quantity;

		var entity = new Entity(pos);

		entity.add(new Sprite(RASPBERRY, C_GREEN, C_GREEN, OBJECTS));
		entity.add(new Moniker('Yarrow leaf'));
		entity.add(new Stackable(STACK_YARROW_LEAF, quantity));
		entity.add(new Loot());
		entity.add(new Destructable());

		return entity;
	}
}
