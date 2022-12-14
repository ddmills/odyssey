package domain.prefabs;

import data.ColorKey;
import domain.components.Inventory;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class LockboxPrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var lockbox = new Entity();

		lockbox.add(new Sprite(CHEST_SMALL_CLOSED, C_BLUE_2, C_YELLOW_2, OBJECTS));
		lockbox.add(new Moniker('Lockbox'));
		lockbox.add(new Loot());

		var inventory = new Inventory();

		inventory.openedTile = CHEST_SMALL_OPEN;
		inventory.openedAudio = CHEST_OPEN;
		inventory.closedAudio = CHEST_CLOSE;

		lockbox.add(inventory);

		inventory.addLoot(Spawner.Spawn(NAVY_REVOLVER));

		inventory.addLoot(Spawner.Spawn(STICK));
		inventory.addLoot(Spawner.Spawn(STICK));
		inventory.addLoot(Spawner.Spawn(STICK));

		return lockbox;
	}
}
