package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Collider;
import domain.components.Destructable;
import domain.components.Forageable;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class RaspberryBushPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(BUSH_1, C_GREEN, C_RED, OBJECTS));
		entity.add(new Moniker('Raspberry bush'));
		entity.add(new Collider());
		entity.add(new Forageable(RASPBERRY, RUSTLING_1, false, C_GREEN, C_GREEN));
		entity.add(new Destructable());

		return entity;
	}
}
