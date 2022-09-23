package domain.prefabs;

import data.ColorKeys;
import domain.components.Collider;
import domain.components.Inventory;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class ChestPrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var chest = new Entity();

		chest.add(new Sprite(CHEST_LARGE_CLOSED, ColorKeys.C_ORANGE_2, ColorKeys.C_BLUE_1, OBJECTS));
		chest.add(new Moniker('Chest'));
		chest.add(new Collider());

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
