package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class HumanCorpsePrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var corpse = new Entity(pos);
		corpse.add(new Sprite(CORPSE_HUMAN, C_WHITE, C_RED, OBJECTS));
		corpse.add(new Moniker('Human corpse'));
		corpse.add(new Loot());

		return corpse;
	}
}
