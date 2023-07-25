package domain.prefabs;

import data.ColorKey;
import domain.components.Collider;
import domain.components.Inventory;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.prefabs.decorators.WoodBuiltDecorator;
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

		WoodBuiltDecorator.Decorate(entity);

		return entity;
	}
}
