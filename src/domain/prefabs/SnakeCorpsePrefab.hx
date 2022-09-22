package domain.prefabs;

import data.ColorKeys;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class SnakeCorpsePrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var corpse = new Entity();
		corpse.add(new Sprite(CORPSE_SNAKE, ColorKeys.C_WHITE_1, ColorKeys.C_RED_1, OBJECTS));
		corpse.add(new Moniker('Snake corpse'));
		corpse.add(new Loot());

		return corpse;
	}
}
