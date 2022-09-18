package domain.prefabs;

import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class AshPilePrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(PILE_ASH, 0x616060, 0x6E6E6E, OBJECTS));
		entity.add(new Moniker('Pile of ashes'));
		entity.add(new Loot());

		return entity;
	}
}
