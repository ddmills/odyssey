package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class FenceIronPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(FENCE_IRON_0, C_GRAY_2, C_GRAY_2, OBJECTS));
		entity.add(new BitmaskSprite([BITMASK_FENCE_IRON, BITMASK_FENCE_BAR]));
		entity.add(new Moniker('Iron fence'));
		entity.add(new Collider());

		return entity;
	}
}
