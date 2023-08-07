package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Fuel;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class LogPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(LOG, C_RED_1, C_RED_2, OBJECTS));
		entity.add(new Moniker('Log'));
		entity.add(new Loot());
		entity.add(new Fuel(FUEL_WOOD, 1200));

		return entity;
	}
}
