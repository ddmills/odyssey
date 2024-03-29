package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.Destructable;
import domain.components.Door;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class BarsDoorPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(BARS_DOOR, C_GRAY_2, C_GRAY_2, OBJECTS));
		entity.add(new Moniker('Iron bar door'));
		entity.add(new Collider());
		entity.add(new BitmaskSprite([BITMASK_FENCE_BAR], false));
		entity.add(new Destructable());

		var door = new Door(BARS_DOOR_OPEN, false);
		door.openedAudio = CHEST_OPEN;
		door.closedAudio = CHEST_CLOSE;
		entity.add(door);

		return entity;
	}
}
