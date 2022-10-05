package domain.prefabs;

import data.ColorKey;
import domain.components.BitmaskSprite;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class RailroadPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(RAILROAD_0, C_GRAY_1, C_RED_2, GROUND));
		entity.add(new BitmaskSprite([BITMASK_RAILROAD]));
		entity.add(new Moniker('Railroad track'));

		return entity;
	}
}
