package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Destructable;
import domain.components.Inventory;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class LockboxPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(CHEST_SMALL_CLOSED, C_BLUE, C_YELLOW, OBJECTS));
		entity.add(new Moniker('Lockbox'));
		entity.add(new Loot());
		entity.add(new Destructable());

		var inventory = new Inventory();

		inventory.openedTile = CHEST_SMALL_OPEN;
		inventory.openedAudio = CHEST_OPEN;
		inventory.closedAudio = CHEST_CLOSE;

		entity.add(inventory);

		inventory.addLoot(Spawner.Spawn(NAVY_REVOLVER, pos));

		inventory.addLoot(Spawner.Spawn(STICK, pos));
		inventory.addLoot(Spawner.Spawn(STICK, pos));
		inventory.addLoot(Spawner.Spawn(STICK, pos));

		return entity;
	}
}
