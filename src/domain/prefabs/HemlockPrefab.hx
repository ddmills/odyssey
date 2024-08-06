package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Destructable;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class HemlockPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(FLOWER_4, C_YELLOW, C_GREEN, OBJECTS));
		entity.add(new Moniker('Hemlock'));
		entity.add(new Destructable());

		return entity;
	}
}
