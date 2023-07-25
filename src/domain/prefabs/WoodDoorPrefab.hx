package domain.prefabs;

import data.ColorKey;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.Destructable;
import domain.components.Door;
import domain.components.LightBlocker;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.prefabs.decorators.WoodBuiltDecorator;
import ecs.Entity;

class WoodDoorPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var isOpen = options.isOpen == null ? false : options.isOpen;
		var entity = new Entity();

		entity.add(new Sprite(DOOR, C_RED_2, C_GRAY_1, OBJECTS));
		entity.add(new Moniker('Door'));
		entity.add(new Collider());
		entity.add(new LightBlocker());
		entity.add(new BitmaskSprite([BITMASK_WALL, BITMASK_WINDOW], false));

		WoodBuiltDecorator.Decorate(entity);

		var door = new Door(DOOR_OPEN);
		door.isOpen = isOpen;
		door.openedAudio = CHEST_OPEN;
		door.closedAudio = CHEST_CLOSE;
		entity.add(door);

		return entity;
	}
}
