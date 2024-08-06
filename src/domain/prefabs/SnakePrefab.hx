package domain.prefabs;

import common.struct.Coordinate;
import domain.components.EquipmentSlot;
import domain.components.Inventory;
import domain.components.Sprite;
import domain.prefabs.decorators.BasicActorDecorator;
import ecs.Entity;

class SnakePrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(SNAKE, C_ORANGE, C_BLACK, ACTORS));

		BasicActorDecorator.Decorate(entity, {
			level: 1,
			faction: FACTION_WILDLIFE,
			savvy: 1,
			finesse: 2,
			moniker: 'Rattlesnake',
			corpse: CORPSE_SNAKE,
		});

		entity.add(new Inventory(false));
		entity.add(new EquipmentSlot('head', 'face', EQ_SLOT_HAND, true));
		entity.get(EquipmentSlot).equip(Spawner.Spawn(STICK, pos));

		return entity;
	}
}
