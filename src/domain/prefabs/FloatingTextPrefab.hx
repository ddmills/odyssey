package domain.prefabs;

import common.struct.Coordinate;
import domain.components.FloatingText;
import ecs.Entity;

class FloatingTextPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new FloatingText(options.text, options.color, options.duration));

		return entity;
	}
}
