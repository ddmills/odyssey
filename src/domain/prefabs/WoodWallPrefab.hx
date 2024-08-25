package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.LightBlocker;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.prefabs.decorators.WoodBuiltDecorator;
import ecs.Entity;

class WoodWallPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(WALL_0, C_WOOD, C_GRAY, OBJECTS));
		entity.add(new BitmaskSprite([
			BITMASK_BRICK,
			BITMASK_CUT_STONE,
			BITMASK_ROCK,
			BITMASK_WINDOW,
			BITMASK_FENCE_BAR
		]));
		entity.add(new Moniker('Wood wall'));
		entity.add(new Collider());
		entity.add(new LightBlocker());

		WoodBuiltDecorator.Decorate(entity);

		return entity;
	}
}
