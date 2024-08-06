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

class BootsPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(BOOTS, C_RED, C_GRAY, OBJECTS));
		entity.add(new Moniker('Boots'));
		entity.add(new Equipment([EQ_SLOT_FEET]));
		entity.add(new Loot());

		var stats = new EquippedStatMod();
		stats.set(STAT_SPEED, 2);
		stats.set(STAT_ARMOR, 1);
		entity.add(stats);

		entity.add(new Destructable());

		return entity;
	}
}
