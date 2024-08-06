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

class PantsPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(PANTS_1, C_RED, C_GRAY, OBJECTS));
		entity.add(new Moniker('Pants'));
		entity.add(new Equipment([EQ_SLOT_LEGS]));
		entity.add(new Loot());
		entity.add(new Destructable());

		var stats = new EquippedStatMod();
		stats.set(STAT_DODGE, 1);
		entity.add(stats);

		return entity;
	}
}
