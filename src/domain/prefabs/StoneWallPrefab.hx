package domain.prefabs;

import common.struct.Coordinate;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.LightBlocker;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.prefabs.decorators.StoneBuiltDecorator;
import ecs.Entity;

class StoneWallPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(WALL_0, C_STONE, C_BLUE, OBJECTS));
		entity.add(new BitmaskSprite([BITMASK_WALL_THICK, BITMASK_WINDOW, BITMASK_FENCE_BAR]));
		entity.add(new Moniker('Stone wall'));
		entity.add(new Collider());
		entity.add(new LightBlocker());

		StoneBuiltDecorator.Decorate(entity);

		return entity;
	}
}
