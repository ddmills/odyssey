package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Destructable;
import domain.components.Equipment;
import domain.components.EquippedStatMod;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class DusterPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);
		entity.add(new Sprite(DUSTER, C_RED, C_GRAY, OBJECTS));
		entity.add(new Moniker('Duster'));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_BODY]));
		entity.add(new Destructable());

		var stats = new EquippedStatMod();
		stats.set(STAT_FORTITUDE, 2);
		stats.set(STAT_ARMOR, 2);

		entity.add(stats);

		entity.get(Equipment).equipAudio = CLOTH_EQUIP_1;
		entity.get(Equipment).unequipAudio = CLOTH_UNEQUIP_1;

		return entity;
	}
}
