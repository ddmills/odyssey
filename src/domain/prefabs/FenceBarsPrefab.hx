package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class FenceBarsPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(FENCE_BARS_0, C_GRAY, C_GRAY, OBJECTS));
		entity.add(new BitmaskSprite([
			BITMASK_FENCE_BAR,
			BITMASK_WALL,
			BITMASK_BRICK,
			BITMASK_CUT_STONE,
			BITMASK_WALL_THICK,
			BITMASK_FENCE_IRON,
			BITMASK_ROCK
		]));
		entity.add(new Moniker('Iron bars'));
		entity.add(new Collider());

		return entity;
	}
}
