package domain.prefabs;

import data.ColorKey;
import domain.components.Explosive;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stackable;
import domain.components.Throwable;
import ecs.Entity;

class DynamitePrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();
		entity.add(new Sprite(DYNAMITE, ColorKey.C_RED_1, C_WHITE_1, OBJECTS));
		entity.add(new Moniker('Dynamite'));
		entity.add(new Loot());
		entity.add(new Stackable(STACK_DYNAMITE));
		entity.add(new Throwable());
		entity.add(new Explosive());

		return entity;
	}
}
