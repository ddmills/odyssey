package domain.prefabs;

import data.ColorKeys;
import domain.components.Collider;
import domain.components.Inventory;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class TallCabinetPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(FURNITURE_TALL_CABINET, ColorKeys.C_ORANGE_2, ColorKeys.C_ORANGE_1, OBJECTS));
		entity.add(new Moniker('Cabinet'));
		entity.add(new Collider());

		var inventory = new Inventory();
		inventory.openedTile = FURNITURE_TALL_CABINET_OPEN;
		inventory.openedAudio = CHEST_OPEN;
		inventory.closedAudio = CHEST_CLOSE;

		entity.add(inventory);

		return entity;
	}
}
