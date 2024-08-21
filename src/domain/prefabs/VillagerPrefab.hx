package domain.prefabs;

import common.struct.Coordinate;
import data.TileKey;
import domain.components.Dialog;
import domain.components.EquipmentSlot;
import domain.components.Inventory;
import domain.components.Sprite;
import domain.prefabs.decorators.BasicActorDecorator;
import domain.prefabs.decorators.HumanoidDecorator;
import ecs.Entity;
import hxd.Rand;

class VillagerPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var r = Rand.create();
		var entity = new Entity(pos);

		BasicActorDecorator.Decorate(entity, {
			moniker: 'Villager',
			level: 6,
			grit: 3,
			savvy: 3,
			finesse: 3,
			faction: FACTION_VILLAGE,
			corpse: CORPSE_HUMAN,
		});
		HumanoidDecorator.Decorate(entity);

		var tkey:TileKey = r.pick([VILLAGER_1, VILLAGER_3, VILLAGER_4]);
		entity.add(new Sprite(tkey, C_WHITE, C_GREEN, ACTORS));

		entity.add(new Dialog([DIALOG_VILLAGER], [DIALOG_OPTION_RUMORS]));

		var eqSlots = entity.getAll(EquipmentSlot);

		var primary = eqSlots.find((s) -> s.isPrimary);
		primary.equip(Spawner.Spawn(REVOLVER, pos));

		var inv = entity.get(Inventory);
		inv.addLoot(Spawner.Spawn(PISTOL_AMMO, pos));
		inv.addLoot(Spawner.Spawn(PISTOL_AMMO, pos));
		inv.addLoot(Spawner.Spawn(PISTOL_AMMO, pos));

		return entity;
	}
}
