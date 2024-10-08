package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.prefabs.decorators.WoodBuiltDecorator;
import ecs.Entity;

class ChairPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(FURNITURE_CHAIR, C_WOOD, C_RED, OBJECTS));
		entity.add(new Moniker('Chair'));

		WoodBuiltDecorator.Decorate(entity);

		return entity;
	}
}
