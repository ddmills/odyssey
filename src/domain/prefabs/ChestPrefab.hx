package domain.prefabs;

import data.SoundResources;
import data.TileResources;
import domain.components.Inventory;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class ChestPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var chest = new Entity();

		chest.add(new Sprite(TileResources.CHEST_LARGE_CLOSED, 0x8D450B, 0xBED4E7, OBJECTS));
		chest.add(new Moniker('Chest'));

		var inventory = new Inventory();
		inventory.openedTile = TileResources.CHEST_LARGE_OPEN;
		inventory.openedSound = SoundResources.CHEST_OPEN;
		inventory.closedSound = SoundResources.CHEST_CLOSE;

		chest.add(inventory);

		inventory.addLoot(Spawner.Spawn(STICK));
		inventory.addLoot(Spawner.Spawn(LOCKBOX));
		inventory.addLoot(Spawner.Spawn(PISTOL));
		inventory.addLoot(Spawner.Spawn(PONCHO));

		return chest;
	}
}
