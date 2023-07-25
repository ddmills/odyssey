package domain.prefabs;

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
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(WALL_0, C_RED_2, C_GRAY_2, OBJECTS));
		entity.add(new BitmaskSprite([BITMASK_WALL, BITMASK_WINDOW]));
		entity.add(new Moniker('Wood wall'));
		entity.add(new Collider());
		entity.add(new LightBlocker());

		WoodBuiltDecorator.Decorate(entity);

		return entity;
	}
}
