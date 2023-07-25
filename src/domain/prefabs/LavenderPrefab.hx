package domain.prefabs;

import data.ColorKey;
import domain.components.Destructable;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class LavenderPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(FLOWER_2, C_PURPLE_1, C_GREEN_1, OBJECTS));
		entity.add(new Moniker('Lavender'));
		entity.add(new Destructable());

		return entity;
	}
}
