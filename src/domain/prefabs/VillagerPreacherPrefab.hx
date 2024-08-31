package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Dialog;
import domain.components.EquipmentSlot;
import domain.components.Inventory;
import domain.components.Sprite;
import domain.prefabs.decorators.BasicCharacterDecorator;
import domain.prefabs.decorators.HumanoidDecorator;
import ecs.Entity;
import hxd.Rand;

class VillagerPreacherPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var r = Rand.create();
		var entity = new Entity(pos);

		BasicCharacterDecorator.Decorate(entity, {
			moniker: 'Preacher',
			level: 12,
			grit: 3,
			savvy: 8,
			finesse: 3,
			faction: FACTION_CHURCH,
			corpse: CORPSE_HUMAN,
		});
		HumanoidDecorator.Decorate(entity);

		entity.add(new Sprite(VILLAGER_2, C_WHITE, C_YELLOW, ACTORS));
		entity.add(new Dialog([DIALOG_VILLAGER_PREACHER], [DIALOG_OPTION_PREACHER]));

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
