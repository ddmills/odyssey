package domain.prefabs;

import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class HumanCorpsePrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var corpse = new Entity();
		corpse.add(new Sprite(CORPSE_HUMAN, 0xDDDBD7, 0x701E1E, OBJECTS));
		corpse.add(new Moniker('Human corpse'));
		corpse.add(new Loot());

		return corpse;
	}
}
