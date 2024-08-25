package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class BarrelPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(BARREL, C_WOOD, C_GRAY, OBJECTS));
		entity.add(new Moniker('Barrel'));
		entity.add(new Collider());

		return entity;
	}
}
