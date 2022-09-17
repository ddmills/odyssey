package domain.systems;

import common.algorithm.Shadowcast;
import core.Frame;
import domain.components.Collider;
import domain.components.Energy;
import domain.components.Explored;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
import domain.components.Visible;
import domain.components.Vision;
import ecs.Query;
import ecs.System;

class VisionSystem extends System
{
	var visibles:Query;

	public function new()
	{
		visibles = new Query({
			all: [Visible],
			none: [IsInventoried, IsDestroyed],
		});

		var vis = new Query({
			any: [Visible, Explored],
			none: [IsDestroyed],
		});
		vis.onEntityAdded((entity) ->
		{
			if (entity.drawable != null)
			{
				entity.drawable.isVisible = true;
			}
		});
		vis.onEntityRemoved((entity) ->
		{
			if (entity.drawable != null)
			{
				entity.drawable.isVisible = false;
			}
		});

		var shrouded = new Query({
			all: [Explored],
			none: [Visible, IsInventoried, IsDestroyed],
		});
		shrouded.onEntityAdded((entity) ->
		{
			if (entity.drawable != null)
			{
				entity.drawable.isShrouded = true;

				if (entity.has(Energy))
				{
					entity.drawable.isVisible = false;
				}
			}
		});
		shrouded.onEntityRemoved((entity) ->
		{
			if (entity.drawable != null)
			{
				entity.drawable.isShrouded = false;
				if (entity.has(Energy))
				{
					entity.drawable.isVisible = true;
				}
			}
		});
	}

	function initialize()
	{
		computeVision();
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
		if (world.clock.tickDelta > 0)
		{
			computeVision();
		}
	}
}
