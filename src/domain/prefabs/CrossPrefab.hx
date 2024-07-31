package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class CrossPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(CROSS, C_RED_3, C_RED_5, OBJECTS));
		entity.add(new Moniker('Cross'));
		entity.add(new Collider());

		return entity;
	}
}
