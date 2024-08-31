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

class ThugPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var r = Rand.create();
		var entity = new Entity(pos);

		var tkey:TileKey = r.pick([BANDIT_1]);
		entity.add(new Sprite(tkey, C_WHITE, C_RED, ACTORS));

		BasicCharacterDecorator.Decorate(entity, {
			moniker: 'Bandit brute',
			level: 3,
			grit: 3,
			faction: FACTION_BANDIT,
			corpse: CORPSE_HUMAN,
		});
		HumanoidDecorator.Decorate(entity);

		var eqSlots = entity.getAll(EquipmentSlot);
		var primary = eqSlots.find((s) -> s.isPrimary);
		primary.equip(Spawner.Spawn(COACH_GUN, pos));

		var inv = entity.get(Inventory);
		inv.addLoot(Spawner.Spawn(SHOTGUN_AMMO, pos));
		inv.addLoot(Spawner.Spawn(SHOTGUN_AMMO, pos));

		return entity;
	}
}
