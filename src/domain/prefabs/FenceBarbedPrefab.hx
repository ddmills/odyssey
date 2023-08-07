package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class FenceBarbedPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(FENCE_BARBED_0, C_RED_2, C_GRAY_2, OBJECTS));
		entity.add(new BitmaskSprite([BITMASK_FENCE_BARBED]));
		entity.add(new Moniker('Barbed wire fence'));
		entity.add(new Collider());

		return entity;
	}
}
