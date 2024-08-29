package domain.ai.behaviours;

import data.ColorKey;
import domain.components.Actor;
import domain.prefabs.Spawner;
import ecs.Entity;

class BehaviourBasic extends Behaviour
{
	override function takeAction(entity:Entity)
	{
		if (tryAttackingNearby(entity))
		{
			return;
		}

		var actor = entity.get(Actor);
		var targets = getVisibleTargets(entity);
		var target = targets.first();

		if (target == null)
		{
			if (!actor.lastKnownTargetPosition.isNull())
			{
				if (tryMoveToward(entity, actor.lastKnownTargetPosition))
				{
					return;
				}
			}

			if (!actor.loiterPosition.isNull())
			{
				actor.lastKnownTargetPosition = null;

				if (tryMoveToward(entity, actor.loiterPosition))
				{
					return;
				}
			}

			wait(entity);
			return;
		}

		if (actor.lastKnownTargetPosition == null)
		{
			Spawner.Spawn(FLOATING_TEXT, entity.pos, {
				text: '!',
				color: ColorKey.C_RED,
				duration: 100
			});
		}

		actor.lastKnownTargetPosition = target.pos;
		var weapon = getPrimaryRangeWeapon(entity);
		if (weapon != null)
		{
			if (tryAttackingRange(entity, target, weapon))
			{
				return;
			}
			if (tryReloading(entity, weapon))
			{
				return;
			}
		}
		if (tryMoveToward(entity, target.pos))
		{
			return;
		}
		wait(entity);
	}
}
