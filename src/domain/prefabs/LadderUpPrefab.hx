package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Moniker;
import domain.components.Portal;
import domain.components.Sprite;
import ecs.Entity;

class LadderUpPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		entity.add(new Sprite(LADDER_UP, C_BROWN, C_WHITE, OBJECTS));
		entity.add(new Moniker('Ladder up'));

		if (options.portalId != null)
		{
			entity.add(new Portal(options.portalId));
		}

		return entity;
	}
}
