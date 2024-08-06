package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Collider;
import domain.components.Inventory;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.prefabs.decorators.WoodBuiltDecorator;
import ecs.Entity;

class ChestPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var chest = new Entity(pos);

		chest.add(new Sprite(CHEST_LARGE_CLOSED, C_WOOD, C_BLUE, OBJECTS));
		chest.add(new Moniker('Chest'));
		chest.add(new Collider());

		var inventory = new Inventory();
		inventory.openedTile = CHEST_LARGE_OPEN;
		inventory.openedAudio = CHEST_OPEN;
		inventory.closedAudio = CHEST_CLOSE;

		chest.add(inventory);

		inventory.addLoot(Spawner.Spawn(STICK, pos));
		inventory.addLoot(Spawner.Spawn(LOCKBOX, pos));
		inventory.addLoot(Spawner.Spawn(NAVY_REVOLVER, pos));
		inventory.addLoot(Spawner.Spawn(PONCHO, pos));
		inventory.addLoot(Spawner.Spawn(STICK, pos));
		inventory.addLoot(Spawner.Spawn(STICK, pos));
		inventory.addLoot(Spawner.Spawn(STICK, pos));

		WoodBuiltDecorator.Decorate(chest);

		return chest;
	}
}
