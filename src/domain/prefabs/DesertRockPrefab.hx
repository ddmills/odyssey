package domain.prefabs;

import common.struct.Coordinate;
import core.Game;
import data.TileKey;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.LightBlocker;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class DesertRockPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(ROCK_ROUND_1, C_RED, C_CLEAR, OBJECTS));
		entity.add(new BitmaskSprite([
			BITMASK_ROCK,
			BITMASK_BRICK,
			BITMASK_CUT_STONE,
			BITMASK_WINDOW,
			BITMASK_FENCE_BAR
		]));
		entity.add(new Moniker('Rock'));
		entity.add(new Collider());
		entity.add(new LightBlocker());

		return entity;
	}
}
