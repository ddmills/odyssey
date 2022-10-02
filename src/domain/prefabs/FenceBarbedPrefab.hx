package domain.prefabs;

import data.ColorKeys;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class FenceBarbedPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(FENCE_BARBED_0, ColorKeys.C_ORANGE_2, ColorKeys.C_GRAY_2, OBJECTS));
		entity.add(new BitmaskSprite([BITMASK_FENCE_BARBED]));
		entity.add(new Moniker('Barbed wire fence'));
		entity.add(new Collider());

		return entity;
	}
}
