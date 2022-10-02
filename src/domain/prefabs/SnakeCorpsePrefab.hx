package domain.prefabs;

import data.ColorKey;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class SnakeCorpsePrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var corpse = new Entity();
		corpse.add(new Sprite(CORPSE_SNAKE, C_WHITE_1, C_RED_1, OBJECTS));
		corpse.add(new Moniker('Snake corpse'));
		corpse.add(new Loot());

		return corpse;
	}
}
