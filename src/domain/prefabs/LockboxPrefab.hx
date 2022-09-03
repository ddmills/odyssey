package domain.prefabs;

import data.SoundResources;
import data.TileResources;
import domain.components.Inventory;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class LockboxPrefab
{
	public static function Create()
	{
		var lockbox = new Entity();

		lockbox.add(new Sprite(TileResources.CHEST_SMALL_CLOSED, 0x909E9E, 0xE2E604, OBJECTS));
		lockbox.add(new Moniker('Lockbox'));
		lockbox.add(new Loot());

		var inventory = new Inventory();

		inventory.openedTile = TileResources.CHEST_SMALL_OPEN;
		inventory.openedSound = SoundResources.CHEST_OPEN;
		inventory.closedSound = SoundResources.CHEST_CLOSE;

		lockbox.add(inventory);

		inventory.addLoot(StickPrefab.Create());

		return lockbox;
	}
}
