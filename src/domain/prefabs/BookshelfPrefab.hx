package domain.prefabs;

import data.ColorKey;
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

		entity.add(new Sprite(FURNITURE_BOOKSHELF, C_ORANGE_2, C_BLUE_1, OBJECTS));
		entity.add(new Moniker('Bookshelf'));
		entity.add(new Collider());
		entity.add(new Inventory());

		return entity;
	}
}
