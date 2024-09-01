package domain.ai.behaviours;

import data.ColorKey;
import domain.components.Actor;
import domain.prefabs.Spawner;
import ecs.Entity;

class BehaviourBasicCompanion extends Behaviour
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

			var leader = actor.leader;

			if (!leader.isNull())
			{
				actor.lastKnownTargetPosition = null;
				if (tryMoveToward(entity, leader.pos, 3))
				{
					return;
				}
			}

			if (!actor.leashPostion.isNull())
			{
				actor.lastKnownTargetPosition = null;

				if (tryMoveToward(entity, actor.leashPostion))
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
