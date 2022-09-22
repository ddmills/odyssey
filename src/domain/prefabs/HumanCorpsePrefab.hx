package domain.prefabs;

import data.ColorKeys;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class HumanCorpsePrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var corpse = new Entity();
		corpse.add(new Sprite(CORPSE_HUMAN, ColorKeys.C_WHITE_1, ColorKeys.C_RED_1, OBJECTS));
		corpse.add(new Moniker('Human corpse'));
		corpse.add(new Loot());

		return corpse;
	}
}
