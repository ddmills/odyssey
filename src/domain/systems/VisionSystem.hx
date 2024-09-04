package domain.systems;

import common.algorithm.Bresenham;
import common.algorithm.Distance;
import common.algorithm.Shadowcast;
import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Frame;
import domain.components.Energy;
import domain.components.Explored;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
import domain.components.LightBlocker;
import domain.components.Visible;
import domain.components.Vision;
import ecs.Entity;
import ecs.Query;
import ecs.System;

class VisionSystem extends System
{
	var visibles:Query;
	var flagRecompute:Bool;

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
			var light = world.systems.lights.getTileLight(entity.pos.toIntPoint());

			if (entity.drawable != null)
			{
				entity.drawable.isVisible = true;
				if (light.intensity > 0)
				{
					entity.drawable.shader.isLit = 1;
					entity.drawable.shader.lightColor = light.color.toHxdColor().toVector();
					entity.drawable.shader.lightIntensity = light.intensity;
				}
				else
				{
					entity.drawable.shader.isLit = 0;
				}
			}
			flagRecompute = true;
		});
		vis.onEntityRemoved((entity) ->
		{
			if (entity.drawable != null)
			{
				entity.drawable.isVisible = false;
				entity.drawable.shader.isLit = 0;
			}
			flagRecompute = true;
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

	public function canSee(source:Entity, target:Coordinate):Bool
	{
		var vision = source.get(Vision);
		if (vision == null)
		{
			return false;
		}
		var a = source.pos.toIntPoint();
		var b = target.toWorld().toIntPoint();
		var distance = Distance.Euclidean(a, b).round();

		if (distance > vision.range)
		{
			return false;
		}

		if (distance > getVisionRange(source))
		{
			var light = world.systems.lights.getTileLight(b);
			if (light.intensity <= 0)
			{
				return false;
			}
		}

		var isVisible = true;
		Bresenham.stroke(a, b, (p) ->
		{
			if (isBlocker(p))
			{
				isVisible = false;
			}
		});

		return isVisible;
	}

	public function getVisionRange(entity:Entity):Int
	{
		var vision = world.player.entity.get(Vision);
		return (world.clock.getDaylight() * vision.range).round();
	}

	private function isBlocker(p:IntPoint)
	{
		if (world.isOutOfBounds(p))
		{
			return false;
		}

		var entities = world.getEntitiesAt(p.asWorld());

		return entities.exists((e) -> e.has(LightBlocker));
	}

	public function computeVision()
	{
		for (entity in visibles)
		{
			entity.remove(Visible);
		}

		world.clearVisible();

		var vision = world.player.entity.get(Vision);
		var range = getVisionRange(world.player.entity);

		Shadowcast.Compute({
			start: world.player.pos.toIntPoint(),
			distance: vision.range,
			isBlocker: isBlocker,
			onLight: (pos, distance) ->
			{
				if (distance > range)
				{
					var light = world.systems.lights.getTileLight(pos);
					if (light.intensity > 0)
					{
						world.setVisible(pos.asWorld());
					}
				}
				else
				{
					world.setVisible(pos.asWorld());
				}
			}
		});

		flagRecompute = false;
	}

	public override function update(frame:Frame)
	{
		if (world.clock.tickDelta > 0 || flagRecompute)
		{
			computeVision();
		}
	}
}
