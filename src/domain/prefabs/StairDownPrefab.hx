package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Moniker;
import domain.components.Portal;
import domain.components.Sprite;
import ecs.Entity;

class StairDownPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(STAIR_DOWN, C_WHITE, C_DARK_GRAY, OBJECTS));
		entity.add(new Moniker('Stair down'));

		if (options.portalId != null)
		{
			entity.add(new Portal(options.portalId));
		}

		return entity;
	}
}
