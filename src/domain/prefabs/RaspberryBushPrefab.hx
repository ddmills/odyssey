package domain.prefabs;

import data.ColorKey;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class RaspberryBushPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(BUSH_1, C_GREEN_4, C_RED_1, OBJECTS));
		entity.add(new Moniker('Raspberry Bush'));
		entity.add(new Collider());

		return entity;
	}
}
