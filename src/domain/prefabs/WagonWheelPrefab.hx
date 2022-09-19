package domain.prefabs;

import domain.components.Fuel;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class WagonWheelPrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(WAGON_WHEEL, 0x814B0D, 0x797979, OBJECTS));
		entity.add(new Moniker('Wagon wheel'));
		entity.add(new Loot());
		entity.add(new Fuel(FUEL_WOOD, 100));

		return entity;
	}
}
