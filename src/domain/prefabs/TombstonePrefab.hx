package domain.prefabs;

import data.ColorKeys;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class TombstonePrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(TOMBSTONE_1, ColorKeys.C_GRAY_1, ColorKeys.C_GRAY_2, OBJECTS));
		entity.add(new Moniker('Tombstone'));
		entity.add(new Collider());

		return entity;
	}
}
