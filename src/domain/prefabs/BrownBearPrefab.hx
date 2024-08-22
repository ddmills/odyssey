package domain.prefabs;

import common.struct.Coordinate;
import domain.components.EquipmentSlot;
import domain.components.Inventory;
import domain.components.Sprite;
import domain.prefabs.decorators.BasicActorDecorator;
import ecs.Entity;

class BrownBearPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(BEAR, C_BROWN, C_RED, ACTORS));
		entity.add(new Inventory(false));

		BasicActorDecorator.Decorate(entity, {
			level: 10,
			faction: FACTION_WILDLIFE,
			grit: 10,
			savvy: 8,
			finesse: 6,
			moniker: 'Brown Bear',
			corpse: CORPSE_SNAKE,
		});

		entity.add(new EquipmentSlot('head', 'face', EQ_SLOT_HAND, true));
		entity.get(EquipmentSlot).equip(Spawner.Spawn(STICK, pos));

		return entity;
	}
}
