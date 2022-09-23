package domain.prefabs;

import data.ColorKeys;
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

		entity.add(new Sprite(LANTERN, ColorKeys.C_BLUE_1, ColorKeys.C_BLACK_1, OBJECTS));
		entity.add(new Moniker('Oil lantern'));
		entity.add(new LightSource(.75, ColorKeys.C_YELLOW_2, 3, false, 3));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_HAND, EQ_SLOT_BELT]));
		entity.add(new Lightable(true, 0xfcefd4));

		return entity;
	}
}
