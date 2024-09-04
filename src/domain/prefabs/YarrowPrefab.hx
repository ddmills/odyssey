package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Destructable;
import domain.components.Forageable;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class YarrowPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		var s = new Sprite(FLOWER_1, C_YELLOW, C_GREEN, OBJECTS);
		entity.add(s);
		entity.add(new Moniker('Yarrow'));
		entity.add(new Forageable(YARROW_LEAF, RUSTLING_1, true));
		entity.add(new Destructable());

		return entity;
	}
}
