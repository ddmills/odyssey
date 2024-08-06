package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Destructable;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sleepable;
import domain.components.Sprite;
import ecs.Entity;

class BedrollPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(BEDROLL, C_PURPLE, C_BLUE, OBJECTS));
		entity.add(new Moniker('Bedroll'));
		entity.add(new Sleepable());
		entity.add(new Loot());
		entity.add(new Destructable());

		return entity;
	}
}
