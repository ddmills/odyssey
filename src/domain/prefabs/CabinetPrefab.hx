package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Collider;
import domain.components.Inventory;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.prefabs.decorators.WoodBuiltDecorator;
import ecs.Entity;

class CabinetPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(FURNITURE_CABINET, C_RED_3, C_RED_1, OBJECTS));
		entity.add(new Moniker('Cabinet'));
		entity.add(new Collider());

		var inventory = new Inventory();
		inventory.openedTile = FURNITURE_CABINET_OPEN;
		inventory.openedAudio = CHEST_OPEN;
		inventory.closedAudio = CHEST_CLOSE;

		entity.add(inventory);

		WoodBuiltDecorator.Decorate(entity);

		return entity;
	}
}
