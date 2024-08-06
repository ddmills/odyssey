package domain.prefabs;

import common.struct.Coordinate;
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
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);
		entity.add(new Sprite(DYNAMITE, C_RED, C_WHITE, OBJECTS));
		entity.add(new Moniker('Dynamite'));
		entity.add(new Loot());
		entity.add(new Stackable(STACK_DYNAMITE));
		entity.add(new Throwable());
		entity.add(new Explosive());

		return entity;
	}
}
