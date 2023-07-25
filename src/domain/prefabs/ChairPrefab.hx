package domain.prefabs;

import data.ColorKey;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.prefabs.decorators.WoodBuiltDecorator;
import ecs.Entity;

class ChairPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(FURNITURE_CHAIR, C_ORANGE_2, C_ORANGE_1, OBJECTS));
		entity.add(new Moniker('Chair'));
		entity.add(new Collider());

		WoodBuiltDecorator.Decorate(entity);

		return entity;
	}
}
