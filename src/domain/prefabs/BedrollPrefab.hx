package domain.prefabs;

import data.ColorKey;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sleepable;
import domain.components.Sprite;
import ecs.Entity;

class BedrollPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(BEDROLL, C_PURPLE_1, C_BLUE_2, OBJECTS));
		entity.add(new Moniker('Bedroll'));
		entity.add(new Sleepable());
		entity.add(new Loot());

		return entity;
	}
}
