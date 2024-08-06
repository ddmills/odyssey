package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Destructable;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class LavenderPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(FLOWER_2, C_PURPLE, C_GREEN, OBJECTS));
		entity.add(new Moniker('Lavender'));
		entity.add(new Destructable());

		return entity;
	}
}
