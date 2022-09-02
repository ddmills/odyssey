package domain.systems;

import common.algorithm.Bresenham;
import common.struct.Coordinate;
import core.Frame;
import domain.components.Energy;
import domain.components.Explored;
import domain.components.Moved;
import domain.components.Sprite;
import domain.components.Visible;
import domain.components.Vision;
import ecs.Query;
import ecs.System;

class VisionSystem extends System
{
	var visions:Query;
	var visibles:Query;
	var recompute:Bool;

	public function new()
	{
		// vision needs to be recomputed if any of the following happens:
		// - entity with Vision spawns
		// - entity with Vision removed
		// - entity Moved

		var moved = new Query({
			all: [Moved]
		});

		visibles = new Query({
			all: [Sprite, Visible]
		});

		visions = new Query({
			all: [Vision]
		});

		moved.onEntityAdded((entity) ->
		{
			recompute = true;
		});

		visions.onEntityAdded((entity) ->
		{
			recompute = true;
		});

		visions.onEntityRemoved((entity) ->
		{
			recompute = true;
		});

		var vis = new Query({
			all: [Sprite],
			any: [Visible, Explored],
		});
		vis.onEntityAdded((entity) ->
		{
			entity.get(Sprite).visible = true;
		});
		vis.onEntityRemoved((entity) ->
		{
			var sprite = entity.get(Sprite);
			if (sprite != null)
			{
				sprite.visible = false;
			}
		});

		var shrouded = new Query({
			all: [Sprite, Explored],
			none: [Visible],
		});
		shrouded.onEntityAdded((entity) ->
		{
			var sprite = entity.get(Sprite);
			sprite.isShrouded = true;
			if (entity.has(Energy))
			{
				sprite.visible = false;
			}
		});
		shrouded.onEntityRemoved((entity) ->
		{
			var sprite = entity.get(Sprite);
			sprite.isShrouded = false;
			if (entity.has(Energy))
			{
				sprite.visible = true;
			}
		});
	}

	function computeVision()
	{
		var visible = new Map<String, Coordinate>();

		visibles.each((e) -> e.remove(Visible));

		for (entity in visions)
		{
			var vision = entity.get(Vision);
			var pos = entity.pos.toIntPoint();

			if (vision.bonus > 0)
			{
				var exploreCircle = Bresenham.getCircle(pos, vision.range + vision.bonus, true);
				for (point in exploreCircle)
				{
					world.explore(new Coordinate(point.x, point.y, WORLD));
				}
			}

			var visCircle = Bresenham.getCircle(pos, vision.range, true);
			var vis = Coordinate.FromPoints(visCircle, WORLD);
			for (coord in vis)
			{
				visible.set(coord.toString(), coord);
			}
		}

		var tiles = visible.map((vis) -> vis);

		world.setVisible(tiles);
	}

	public override function update(frame:Frame)
	{
		if (recompute)
		{
			computeVision();
			recompute = false;
		}
	}
}
