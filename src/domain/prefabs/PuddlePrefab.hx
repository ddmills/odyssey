package domain.prefabs;

import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class PuddlePrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(PUDDLE_1, 0x000000, 0xffffff, GROUND));
		entity.add(new Moniker('puddle'));

		return entity;
	}
}
