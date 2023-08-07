package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class SnakeCorpsePrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var corpse = new Entity(pos);
		corpse.add(new Sprite(CORPSE_SNAKE, C_YELLOW_0, C_RED_1, OBJECTS));
		corpse.add(new Moniker('Snake corpse'));
		corpse.add(new Loot());

		return corpse;
	}
}
