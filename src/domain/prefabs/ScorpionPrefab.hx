package domain.prefabs;

import common.struct.Coordinate;
import domain.components.EquipmentSlot;
import domain.components.Inventory;
import domain.components.Sprite;
import domain.prefabs.decorators.BasicCharacterDecorator;
import ecs.Entity;

class ScorpionPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(SCORPION, C_ORANGE, C_WHITE, ACTORS));
		entity.add(new Inventory(false));

		BasicCharacterDecorator.Decorate(entity, {
			level: 6,
			faction: FACTION_WILDLIFE,
			grit: 4,
			savvy: 0,
			finesse: 4,
			moniker: 'Scorpion',
			corpse: CORPSE_SNAKE,
		});

		entity.add(new EquipmentSlot('head', 'face', EQ_SLOT_HAND, true));
		entity.get(EquipmentSlot).equip(Spawner.Spawn(STICK, pos));

		return entity;
	}
}
