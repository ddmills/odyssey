package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class LadderDownPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(LADDER_DOWN, C_BROWN, C_DARK_GRAY, OBJECTS));
		entity.add(new Moniker('Ladder down'));

		return entity;
	}
}
