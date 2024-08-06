package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Dialog;
import domain.components.EquipmentSlot;
import domain.components.Inventory;
import domain.components.Sprite;
import domain.prefabs.decorators.BasicActorDecorator;
import ecs.Entity;

class WolfPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(WOLF, C_GRAY, C_DARK_RED, ACTORS));
		entity.add(new Dialog([DIALOG_WOLF]));
		entity.add(new Inventory(false));

		BasicActorDecorator.Decorate(entity, {
			level: 2,
			faction: FACTION_WILDLIFE,
			grit: 3,
			savvy: 2,
			finesse: 1,
			moniker: 'Wolf',
			corpse: CORPSE_SNAKE,
		});

		entity.add(new EquipmentSlot('head', 'face', EQ_SLOT_HAND, true));
		entity.get(EquipmentSlot).equip(Spawner.Spawn(STICK, pos));

		return entity;
	}
}
