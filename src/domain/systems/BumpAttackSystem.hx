package domain.systems;

import common.struct.FloatPoint;
import core.Frame;
import domain.components.BumpAttack;
import domain.components.IsDestroyed;
import domain.components.Move;
import domain.components.Sprite;
import ecs.Query;
import ecs.System;

class BumpAttackSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [BumpAttack, Sprite],
			none: [IsDestroyed],
		});

		query.onEntityAdded((e) ->
		{
			var bump = e.get(BumpAttack);
			bump.startTime = game.frame.elapsed;
		});
	}

	override function update(frame:Frame)
	{
		for (entity in query)
		{
			if (entity.has(Move))
			{
				continue;
			}

			var bump = entity.get(BumpAttack);
			var currentDuration = frame.elapsed - bump.startTime;
			var progress = (currentDuration / bump.duration).clamp(0, 1);
			var offset = bump.direction.toOffset();
			var target = new FloatPoint(offset.x * .5, offset.y * .5);
			var goal = entity.pos.add(target.asWorld());
			var newPos = entity.pos.easeZig(goal, progress, bump.ease);

			entity.drawable.pos = newPos;

			if (progress >= 1)
			{
				entity.drawable.pos = null;
				entity.remove(BumpAttack);
			}
		}
	}
}
