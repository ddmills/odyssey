package domain.prefabs;

import common.struct.Coordinate;
import domain.components.LightBlocker;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class TallGrassPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(TALL_GRASS, C_GREEN, C_WOOD, OBJECTS));
		entity.add(new Moniker('Tall grass'));
		entity.add(new LightBlocker());

		return entity;
	}
}
