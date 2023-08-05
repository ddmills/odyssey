package domain.prefabs;

import data.ColorKey;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.prefabs.decorators.WoodBuiltDecorator;
import ecs.Entity;

class TablePrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(FURNITURE_TABLE, C_RED_3, C_RED_2, OBJECTS));
		entity.add(new Moniker('Table'));
		entity.add(new Collider());

		WoodBuiltDecorator.Decorate(entity);

		return entity;
	}
}
