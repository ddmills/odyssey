package domain.prefabs;

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
	public function Create(options:Dynamic):Entity
	{
		var isLit = options.isLit == null ? false : options.isLit;
		var entity = new Entity();

		entity.add(new Sprite(LANTERN, C_BLUE_1, C_BLACK, OBJECTS));
		entity.add(new Moniker('Oil lantern'));
		entity.add(new Lightable(true, C_YELLOW_1));
		entity.add(new LightSource(.5, C_YELLOW_1, 5, isLit));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_HAND, EQ_SLOT_BELT]));
		entity.add(new Destructable());

		return entity;
	}
}
