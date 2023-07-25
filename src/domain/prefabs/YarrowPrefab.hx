package domain.prefabs;

import data.ColorKey;
import domain.components.Forageable;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class YarrowPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(FLOWER_1, C_WHITE_1, C_GREEN_1, OBJECTS));
		entity.add(new Moniker('Yarrow'));
		entity.add(new Forageable(YARROW_LEAF, RUSTLING_1, true));

		return entity;
	}
}
