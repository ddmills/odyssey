package domain.prefabs;

import data.ColorKeys;
import domain.components.Collider;
import domain.components.Inventory;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class BookshelfPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(FURNITURE_BOOKSHELF, ColorKeys.C_ORANGE_2, ColorKeys.C_ORANGE_1, OBJECTS));
		entity.add(new Moniker('Bookshelf'));
		entity.add(new Collider());
		entity.add(new Inventory());

		return entity;
	}
}
