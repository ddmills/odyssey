package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.EquipmentSlot;
import domain.components.Inventory;
import domain.components.LightSource;
import domain.components.Sprite;
import domain.prefabs.decorators.BasicCharacterDecorator;
import ecs.Entity;

class FireflyPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(FIREFLY, C_WHITE, C_YELLOW, ACTORS));
		entity.add(new LightSource(1.6, ColorKey.C_YELLOW, 4));

		BasicCharacterDecorator.Decorate(entity, {
			level: 1,
			faction: FACTION_WILDLIFE,
			savvy: 3,
			finesse: 5,
			moniker: 'Giant Firefly',
			corpse: CORPSE_SNAKE,
		});

		entity.add(new Inventory(false));
		entity.add(new EquipmentSlot('head', 'face', EQ_SLOT_HAND, true));
		entity.get(EquipmentSlot).equip(Spawner.Spawn(STICK, pos));

		return entity;
	}
}
