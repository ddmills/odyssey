package domain.prefabs;

import data.AudioResources;
import data.TileResources;
import domain.components.Blocker;
import domain.components.Inventory;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class ChestPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var chest = new Entity();

		chest.add(new Sprite(CHEST_LARGE_CLOSED, 0x8D450B, 0xBED4E7, OBJECTS));
		chest.add(new Moniker('Chest'));
		chest.add(new Blocker());

		var inventory = new Inventory();
		inventory.openedTile = CHEST_LARGE_OPEN;
		inventory.openedAudio = CHEST_OPEN;
		inventory.closedAudio = CHEST_CLOSE;

		chest.add(inventory);

		inventory.addLoot(Spawner.Spawn(STICK));
		inventory.addLoot(Spawner.Spawn(LOCKBOX));
		inventory.addLoot(Spawner.Spawn(NAVY_REVOLVER));
		inventory.addLoot(Spawner.Spawn(PONCHO));
		inventory.addLoot(Spawner.Spawn(STICK));
		inventory.addLoot(Spawner.Spawn(STICK));
		inventory.addLoot(Spawner.Spawn(STICK));

		return chest;
	}
}
