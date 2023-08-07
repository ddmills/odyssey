package domain.prefabs;

import common.struct.Coordinate;
import ecs.Entity;

class JohnnyAppleseedPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		return entity;
	}
}
