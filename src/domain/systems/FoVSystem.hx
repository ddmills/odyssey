package domain.systems;

import common.algorithm.Shadowcast;
import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Frame;
import domain.components.Collider;
import domain.components.Vision;
import ecs.System;

class FoVSystem extends System
{
	public function new() {}

	override function update(frame:Frame)
	{
		if (world.clock.tickDelta <= 0)
		{
			return;
		}

		computeVision();
	}

	public function computeVision()
	{
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
}
