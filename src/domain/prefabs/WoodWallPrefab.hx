package domain.prefabs;

import data.ColorKeys;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.LightBlocker;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class WoodWallPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(WALL_0, ColorKeys.C_RED_2, ColorKeys.C_GRAY_2, OBJECTS));
		entity.add(new BitmaskSprite([BITMASK_WALL, BITMASK_WINDOW]));
		entity.add(new Moniker('Wood wall'));
		entity.add(new Collider());
		entity.add(new LightBlocker());

		return entity;
	}
}
