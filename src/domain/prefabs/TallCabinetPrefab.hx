package domain.prefabs;

import data.ColorKey;
import domain.components.Collider;
import domain.components.Inventory;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.prefabs.decorators.WoodBuiltDecorator;
import ecs.Entity;

class TallCabinetPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(FURNITURE_TALL_CABINET, C_ORANGE_2, C_ORANGE_1, OBJECTS));
		entity.add(new Moniker('Cabinet'));
		entity.add(new Collider());

		var inventory = new Inventory();
		inventory.openedTile = FURNITURE_TALL_CABINET_OPEN;
		inventory.openedAudio = CHEST_OPEN;
		inventory.closedAudio = CHEST_CLOSE;

		entity.add(inventory);

		WoodBuiltDecorator.Decorate(entity);

		return entity;
	}
}
