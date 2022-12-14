package domain.prefabs;

import data.ColorKey;
import domain.components.Collider;
import domain.components.Inventory;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class ShelfPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(FURNITURE_SHELF, C_ORANGE_2, C_ORANGE_1, OBJECTS));
		entity.add(new Moniker('Shelf'));
		entity.add(new Collider());
		entity.add(new Inventory());

		return entity;
	}
}
