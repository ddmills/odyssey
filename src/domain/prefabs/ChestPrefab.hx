package domain.prefabs;

import data.SoundResources;
import data.TileResources;
import domain.components.Inventory;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class ChestPrefab
{
	public static function Create()
	{
		var chest = new Entity();

		chest.add(new Sprite(TileResources.CHEST_LARGE_CLOSED, 0x8D450B, 0xBED4E7, OBJECTS));
		chest.add(new Moniker('Chest'));

		var inventory = new Inventory();
		inventory.openedTile = TileResources.CHEST_LARGE_OPEN;
		inventory.openedSound = SoundResources.CHEST_OPEN;
		inventory.closedSound = SoundResources.CHEST_CLOSE;

		chest.add(inventory);

		inventory.addLoot(StickPrefab.Create());
		inventory.addLoot(StickPrefab.Create());
		inventory.addLoot(LockboxPrefab.Create());

		return chest;
	}
}
