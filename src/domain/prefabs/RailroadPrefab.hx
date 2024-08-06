package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.BitmaskSprite;
import domain.components.Destructable;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class RailroadPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(RAILROAD_0, C_BLUE, C_WOOD, GROUND));
		entity.add(new BitmaskSprite([BITMASK_RAILROAD]));
		entity.add(new Moniker('Railroad track'));
		entity.add(new Destructable());

		return entity;
	}
}
