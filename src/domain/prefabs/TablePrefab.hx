package domain.prefabs;

import data.ColorKey;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class TablePrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(FURNITURE_TABLE, C_ORANGE_2, C_ORANGE_1, OBJECTS));
		entity.add(new Moniker('Table'));
		entity.add(new Collider());

		return entity;
	}
}
