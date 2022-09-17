package domain.systems;

import common.algorithm.Shadowcast;
import core.Frame;
import domain.components.Collider;
import domain.components.Energy;
import domain.components.Explored;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
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
		var moved = new Query({
			all: [Moved],
			none: [IsInventoried, IsDestroyed],
		});

		visibles = new Query({
			all: [Sprite, Visible],
			none: [IsInventoried, IsDestroyed],
		});

		visions = new Query({
			all: [Vision],
			none: [IsInventoried, IsDestroyed],
		});

		moved.onEntityAdded((entity) ->
		{
			recompute = true;
		});

		// visions.onEntityAdded((entity) ->
		// {
		// 	recompute = true;
		// });

		// visions.onEntityRemoved((entity) ->
		// {
		// 	recompute = true;
		// });

		var vis = new Query({
			all: [Sprite],
			any: [Visible, Explored],
			none: [IsDestroyed],
		});
		vis.onEntityAdded((entity) ->
		{
			entity.get(Sprite).isVisible = true;
		});
		vis.onEntityRemoved((entity) ->
		{
			var sprite = entity.get(Sprite);
			if (sprite != null)
			{
				sprite.isVisible = false;
			}
		});

		var shrouded = new Query({
			all: [Sprite, Explored],
			none: [Visible, IsInventoried, IsDestroyed],
		});
		shrouded.onEntityAdded((entity) ->
		{
			var sprite = entity.get(Sprite);
			sprite.isShrouded = true;
			if (entity.has(Energy))
			{
				sprite.isVisible = false;
			}
		});
		shrouded.onEntityRemoved((entity) ->
		{
			var sprite = entity.get(Sprite);
			if (sprite != null)
			{
				sprite.isShrouded = false;
				if (entity.has(Energy))
				{
					sprite.isVisible = true;
				}
			}
		});
	}

	function initialize()
	{
		recompute = true;
	}

	function computeVision()
	{
		for (entity in visibles)
		{
			entity.remove(Visible);
		}

		world.clearVisible();
		Shadowcast.Compute({
			start: world.player.pos.toIntPoint(),
			distance: world.player.entity.get(Vision).range,
			decay: 0,
			isBlocker: (p) ->
			{
				if (world.map.tiles.isOutOfBounds(p.x, p.y))
				{
					return false;
				}

				var entities = world.getEntitiesAt(p.asWorld());

				return entities.exists((e) -> e.has(Collider));
			},
			onLight: (pos, brightness) ->
			{
				world.setVisible(pos.asWorld());
			}
		});
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
