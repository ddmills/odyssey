package domain.ai.behaviours;

import common.algorithm.Distance;
import data.ColorKey;
import domain.components.Actor;
import domain.components.HitBlink;
import domain.prefabs.Spawner;
import ecs.Entity;

class BehaviourZombie extends Behaviour
{
	override function takeAction(entity:Entity)
	{
		var actor = entity.get(Actor);
		var target = getTarget(entity);

		if (target != null)
		{
			if (actor.lastKnownTargetPosition.isNull())
			{
				var blink = new HitBlink();
				blink.color = C_ORANGE;
				entity.add(blink);
				Spawner.Spawn(FLOATING_TEXT, entity.pos, {
					text: '!',
					color: ColorKey.C_RED,
					duration: 100
				});
			}
			actor.lastKnownTargetPosition = target.pos;
		}

		var actorPos = entity.pos.toIntPoint();
		var leashPos = actor.leashPostion.toIntPoint();

		if (!actor.isReturningToLeash && actor.lastKnownTargetPosition != null)
		{
			var goalPos = actor.lastKnownTargetPosition.toIntPoint();

			var distanceFromLeash = Distance.Diagonal(leashPos, actorPos);
			var distanceToTarget = Distance.Diagonal(leashPos, goalPos);

			if (distanceToTarget < actor.leashDistance && distanceFromLeash < actor.leashDistance)
			{
				if (target != null)
				{
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
					else
					{
						if (tryAttackingNearby(entity))
						{
							return;
						}
					}
				}

				if (tryMoveToward(entity, actor.lastKnownTargetPosition))
				{
					return;
				}

				trace('failed to move toward target');
				wait(entity);
			}

			trace('return to leash home');
			actor.isReturningToLeash = true;
			actor.lastKnownTargetPosition = null;
		}

		if (actor.leashPostion.isNull())
		{
			trace('null wtf');
			wait(entity);
			return;
		}

		// return to leash position
		if (tryMoveToward(entity, actor.leashPostion))
		{
			return;
		}

		if (actorPos.equals(leashPos))
		{
			actor.isReturningToLeash = false;
		}

		wait(entity);
	}
}
