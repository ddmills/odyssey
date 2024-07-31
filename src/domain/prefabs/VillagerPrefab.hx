package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import data.FactionType;
import data.TileKey;
import domain.components.Dialog;
import domain.components.EquipmentSlot;
import domain.components.FactionMember;
import domain.components.Health;
import domain.components.Inventory;
import domain.components.Moniker;
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

		var tkey:TileKey = r.pick([PERSON_1, PERSON_2, PERSON_3, PERSON_5, PERSON_6, PERSON_7]);
		entity.add(new Sprite(tkey, C_YELLOW_0, C_GREEN_2, ACTORS));

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
