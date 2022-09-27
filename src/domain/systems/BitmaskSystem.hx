package domain.systems;

import common.struct.IntPoint;
import data.BitmaskType;
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

	public function getMaskNeighbors(pos:IntPoint, types:Array<BitmaskType>)
	{
		var neighbors = world.getNeighborEntities(pos);

		return neighbors.map((list) ->
		{
			return list.filter((e) ->
			{
				if (!e.has(BitmaskSprite) || !e.has(Explored) || e.has(IsDestroyed))
				{
					return false;
				}

				return e.get(BitmaskSprite).bitmaskTypes.intersects(types);
			});
		});
	}

	public function refreshMaskAndNeighbors(entity:Entity)
	{
		refreshMask(entity);

		var bitmaskTypes = entity.get(BitmaskSprite).bitmaskTypes;
		var neighbors = getMaskNeighbors(entity.pos.toWorld().toIntPoint(), bitmaskTypes);
		for (list in neighbors)
		{
			for (neighbor in list)
			{
				refreshMask(neighbor);
			}
		}
	}

	public function refreshMask(entity:Entity)
	{
		var bitmaskSprite = entity.get(BitmaskSprite);

		if (!bitmaskSprite.overwriteTile)
		{
			return;
		}

		var neighbors = getMaskNeighbors(entity.pos.toWorld().toIntPoint(), bitmaskSprite.bitmaskTypes);
		var mask = sumMask(neighbors);
		var tileKey = Bitmasks.GetTileKey(bitmaskSprite.bitmaskType, mask);
		var sprite = entity.get(Sprite);

		sprite.tileKey = tileKey;
	}

	public function computeMask(entity:Entity):Int
	{
		var bitmaskSprite = entity.get(BitmaskSprite);

		if (bitmaskSprite == null)
		{
			return 0;
		}

		var neighbors = getMaskNeighbors(entity.pos.toWorld().toIntPoint(), bitmaskSprite.bitmaskTypes);
		return sumMask(neighbors);
	}

	public function sumMask(neighbors:Array<Array<Entity>>):Int
	{
		return neighbors.foldi((cell, sum, idx) ->
		{
			return cell.length > 0 ? sum + 2.pow(idx) : sum;
		}, 0);
	}
}
