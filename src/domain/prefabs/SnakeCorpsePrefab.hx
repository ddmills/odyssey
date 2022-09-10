package domain.prefabs;

import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class SnakeCorpsePrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var corpse = new Entity();
		corpse.add(new Sprite(CORPSE_SNAKE, 0xDF9100, 0xAC1111, OBJECTS));
		corpse.add(new Moniker('Snake corpse'));
		corpse.add(new Loot());

		return corpse;
	}
}
