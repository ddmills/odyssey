package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Fuel;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.prefabs.decorators.WoodBuiltDecorator;
import ecs.Entity;

class WagonWheelPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(WAGON_WHEEL, C_RED_3, C_BLUE_1, OBJECTS));
		entity.add(new Moniker('Wagon wheel'));
		entity.add(new Loot());
		entity.add(new Fuel(FUEL_WOOD, 100, true));

		WoodBuiltDecorator.Decorate(entity);

		return entity;
	}
}
