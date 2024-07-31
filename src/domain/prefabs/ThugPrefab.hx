package domain.prefabs;

import common.struct.Coordinate;
import data.TileKey;
import domain.components.EquipmentSlot;
import domain.components.Inventory;
import domain.components.Sprite;
import domain.prefabs.decorators.BasicActorDecorator;
import domain.prefabs.decorators.HumanoidDecorator;
import ecs.Entity;
import hxd.Rand;

class ThugPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var r = Rand.create();
		var entity = new Entity(pos);

		var tkey:TileKey = r.pick([PERSON_1, PERSON_2, PERSON_3, PERSON_5, PERSON_6, PERSON_7]);
		entity.add(new Sprite(tkey, C_YELLOW_0, C_RED_1, ACTORS));

		BasicActorDecorator.Decorate(entity, {
			moniker: 'Thug brute',
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
