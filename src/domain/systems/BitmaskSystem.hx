package domain.systems;

import common.struct.Coordinate;
import data.Bitmasks;
import domain.components.BitmaskSprite;
import domain.components.Explored;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
import domain.components.Sprite;
import ecs.Entity;
import ecs.Query;
import ecs.System;

class BitmaskSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [Sprite, BitmaskSprite, Explored],
			none: [IsInventoried, IsDestroyed],
		});

		query.onEntityAdded((e) ->
		{
			refreshMaskAndNeighbors(e);
		});
	}

	function refreshMaskAndNeighbors(entity:Entity)
	{
		refreshMask(entity);

		var bitmaskTypes = entity.get(BitmaskSprite).bitmaskTypes;
		var pos = entity.pos.toWorld().toIntPoint();
		var neighbors = world.getNeighborEntities(pos);

		for (list in neighbors)
		{
			for (e in list)
			{
				if (!e.has(BitmaskSprite) || !e.has(Explored) || e.has(IsDestroyed))
				{
					continue;
				}

				if (bitmaskTypes.intersects(e.get(BitmaskSprite).bitmaskTypes))
				{
					refreshMask(e);
				}
			}
		}
	}

	function refreshMask(entity:Entity)
	{
		var bitmaskSprite = entity.get(BitmaskSprite);

		if (!bitmaskSprite.overwriteTile)
		{
			return;
		}

		var mask = compute(entity);
		var tileKey = Bitmasks.GetTileKey(bitmaskSprite.bitmaskType, mask);
		var sprite = entity.get(Sprite);

		sprite.tileKey = tileKey;
	}

	function compute(entity:Entity):Int
	{
		var bitmaskSprite = entity.get(BitmaskSprite);
		var invert = bitmaskSprite.bitmask.invertUnexplored;

		return Bitmasks.SumMask((x, y) ->
		{
			var pos = entity.pos.toIntPoint().add(x, y).asWorld();
			var list = world.getEntitiesAt(pos);

			for (e in list)
			{
				if (!invert && !e.has(Explored))
				{
					continue;
				}

				if (!e.has(BitmaskSprite) || e.has(IsDestroyed))
				{
					continue;
				}

				if (bitmaskSprite.bitmaskTypes.contains(e.get(BitmaskSprite).bitmaskType))
				{
					return true;
				}
			}

			return false;
		});
	}
}
