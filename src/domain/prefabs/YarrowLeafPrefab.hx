package domain.prefabs;

import data.ColorKey;
import domain.components.Destructable;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stackable;
import ecs.Entity;

class YarrowLeafPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var quantity:Int = options.quantity == null ? 1 : options.quantity;

		var entity = new Entity();

		entity.add(new Sprite(RASPBERRY, C_GREEN_1, C_GREEN_4, OBJECTS));
		entity.add(new Moniker('Yarrow leaf'));
		entity.add(new Stackable(STACK_YARROW_LEAF, quantity));
		entity.add(new Loot());
		entity.add(new Destructable());

		return entity;
	}
}
