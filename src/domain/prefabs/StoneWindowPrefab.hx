package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class StoneWindowPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(WALL_WINDOW_H, C_STONE, C_BLUE, OBJECTS));
		entity.add(new BitmaskSprite([BITMASK_WINDOW, BITMASK_WALL, BITMASK_WALL_THICK]));
		entity.add(new Moniker('Window'));
		entity.add(new Collider());

		return entity;
	}
}
