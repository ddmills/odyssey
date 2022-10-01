package domain.prefabs;

import data.ColorKeys;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class ChairPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(FURNITURE_CHAIR, ColorKeys.C_ORANGE_2, ColorKeys.C_ORANGE_1, OBJECTS));
		entity.add(new Moniker('Chair'));
		entity.add(new Collider());

		return entity;
	}
}
