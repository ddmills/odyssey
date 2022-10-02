package domain.prefabs;

import data.ColorKey;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class FenceBarsPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(FENCE_BARS_0, C_GRAY_2, C_GRAY_2, OBJECTS));
		entity.add(new BitmaskSprite([BITMASK_FENCE_BAR, BITMASK_WALL, BITMASK_FENCE_IRON]));
		entity.add(new Moniker('Iron bars'));
		entity.add(new Collider());

		return entity;
	}
}
