package domain.prefabs;

import data.ColorKeys;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class WindowPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(WALL_WINDOW_H, ColorKeys.C_RED_2, ColorKeys.C_BLUE_1, OBJECTS));
		entity.add(new BitmaskSprite([BITMASK_WINDOW, BITMASK_WALL]));
		entity.add(new Moniker('Window'));
		entity.add(new Collider());

		return entity;
	}
}
