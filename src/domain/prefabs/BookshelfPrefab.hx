package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Collider;
import domain.components.Inventory;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.prefabs.decorators.WoodBuiltDecorator;
import ecs.Entity;

class BookshelfPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(FURNITURE_BOOKSHELF, C_RED_3, C_BLUE_1, OBJECTS));
		entity.add(new Moniker('Bookshelf'));
		entity.add(new Collider());
		entity.add(new Inventory());

		WoodBuiltDecorator.Decorate(entity);

		return entity;
	}
}
