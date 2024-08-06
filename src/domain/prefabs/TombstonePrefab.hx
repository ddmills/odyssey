package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class TombstonePrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(TOMBSTONE_1, C_GRAY, C_GRAY, OBJECTS));
		entity.add(new Moniker('Tombstone'));
		entity.add(new Collider());

		return entity;
	}
}
