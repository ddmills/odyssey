package domain.prefabs;

import domain.components.Equipment;
import domain.components.LightSource;
import domain.components.Lightable;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class LanternPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(LANTERN, 0x918883, 0x121213, OBJECTS));
		entity.add(new Moniker('Oil lantern'));
		entity.add(new LightSource(.4, 0xf37d1d, 6, false, 6));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_HAND, EQ_SLOT_BELT]));
		entity.add(new Lightable(true, 0xfcefd4));

		return entity;
	}
}
