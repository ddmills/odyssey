package domain.prefabs;

import data.ColorKey;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class YarrowPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(FLOWER_1, C_YELLOW_1, C_GREEN_1, OBJECTS));
		entity.add(new Moniker('Yarrow'));

		return entity;
	}
}
