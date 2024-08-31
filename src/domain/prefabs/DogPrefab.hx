package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Dialog;
import domain.components.EquipmentSlot;
import domain.components.Inventory;
import domain.components.Sprite;
import domain.prefabs.decorators.BasicCharacterDecorator;
import ecs.Entity;

class DogPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(DOG, C_BROWN, C_DARK_RED, ACTORS));
		entity.add(new Dialog([DIALOG_DOG]));
		entity.add(new Inventory(false));

		BasicCharacterDecorator.Decorate(entity, {
			level: 10,
			faction: FACTION_DOGS,
			grit: 3,
			savvy: 3,
			finesse: 3,
			moniker: 'Dog',
			corpse: CORPSE_SNAKE,
		});

		entity.add(new EquipmentSlot('head', 'face', EQ_SLOT_HAND, true));
		entity.get(EquipmentSlot).equip(Spawner.Spawn(STICK, pos));

		return entity;
	}
}
