package domain.prefabs;

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

		return entity;
	}
}
