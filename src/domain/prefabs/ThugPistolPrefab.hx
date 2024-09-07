package domain.prefabs;

import common.struct.Coordinate;
import data.TileKey;
import domain.components.EquipmentSlot;
import domain.components.Inventory;
import domain.components.Sprite;
import domain.prefabs.decorators.BasicCharacterDecorator;
import domain.prefabs.decorators.HumanoidDecorator;
import ecs.Entity;
import hxd.Rand;

class ThugPistolPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var r = Rand.create();
		var entity = new Entity(pos);

		entity.add(new Sprite(BANDIT_1, C_WHITE, C_RED, ACTORS));

		BasicCharacterDecorator.Decorate(entity, {
			moniker: 'Bandit',
			level: 3,
			grit: 1,
			finesse: 5,
			faction: FACTION_BANDIT,
			corpse: CORPSE_HUMAN,
		});
		HumanoidDecorator.Decorate(entity);

		var eqSlots = entity.getAll(EquipmentSlot);
		var primary = eqSlots.find((s) -> s.isPrimary);
		primary.equip(Spawner.Spawn(NAVY_REVOLVER, pos));

		var inv = entity.get(Inventory);
		inv.addLoot(Spawner.Spawn(PISTOL_AMMO, pos));
		inv.addLoot(Spawner.Spawn(PISTOL_AMMO, pos));

		return entity;
	}
}
