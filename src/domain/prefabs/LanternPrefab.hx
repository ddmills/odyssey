package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Destructable;
import domain.components.Equipment;
import domain.components.LightSource;
import domain.components.Lightable;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class LanternPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var isLit = options.isLit == null ? false : options.isLit;
		var entity = new Entity(pos);

		entity.add(new Sprite(LANTERN, C_BLUE, C_BLACK, OBJECTS));
		entity.add(new Moniker('Oil lantern'));
		entity.add(new Lightable(true, C_YELLOW));
		entity.add(new LightSource(1, C_FIRE_LIGHT, 4, isLit));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_HAND, EQ_SLOT_BELT]));
		entity.add(new Destructable());

		return entity;
	}
}
