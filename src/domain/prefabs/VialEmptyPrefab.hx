package domain.prefabs;

import domain.components.LiquidContainer;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class VialEmptyPrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(VIAL, 0x8ac1ee, 0x121213, OBJECTS));
		entity.add(new Moniker('Vial'));
		entity.add(new Loot());
		entity.add(new LiquidContainer(LIQUID_WATER, 0, 80, true, true, true, false, false));

		return entity;
	}
}
