package domain.ai.behaviours;

import core.Game;
import data.Cardinal;
import domain.components.Collider;
import domain.components.Health;
import domain.components.IsEnemy;
import domain.components.IsPlayer;
import domain.components.Move;
import domain.events.MeleeEvent;
import domain.events.ReloadEvent;
import domain.events.ShootEvent;
import domain.systems.EnergySystem;
import ecs.Entity;

class BehaviourBasic extends Behaviour
{
	override function takeAction(entity:Entity)
	{
		if (tryAttackingNearby(entity))
		{
			return;
		}

		var targets = getVisibleTargets(entity);
		var target = targets.first();

		if (target != null)
		{
			if (tryMoveToward(entity, target.pos))
			{
				return;
			}
		}

		// if (tryAttackingRange(entity))
		// {
		// 	return;
		// }

		// if (tryReloading(entity))
		// {
		// 	return;
		// }

		// if (tryMove(entity))
		// {
		// 	return;
		// }

		wait(entity);
	}

	public function tryMove(entity:Entity):Bool
	{
		var doMove = r.bool(.5);

		if (!doMove)
		{
			return false;
		}

		var delta = r.pick(Cardinal.values).toOffset();
		var goal = entity.pos.add(delta.asWorld()).ciel();

		var chunkIdx = goal.toChunkIdx();
		var chunk = Game.instance.world.chunks.getChunkById(chunkIdx);

		if (chunk == null || !chunk.isLoaded)
		{
			return false;
		}

		if (Game.instance.world.getEntitiesAt(goal).exists((e) -> e.has(Collider) || e.has(IsPlayer) || e.has(IsEnemy)))
		{
			return false;
		}

		EnergySystem.ConsumeEnergy(entity, ACT_MOVE);

		var fast = entity.has(Move);
		entity.add(new Move(goal, fast ? .1 : .2, EASE_LINEAR));

		return true;
	}

	public function tryReloading(entity:Entity):Bool
	{
		var reload = new ReloadEvent(entity);
		entity.fireEvent(reload);
		return reload.isHandled;
	}

	public function tryAttackingRange(entity:Entity):Bool
	{
		var factions = Game.instance.world.factions;
		var inRange = Game.instance.world.getEntitiesInRange(entity.pos.toIntPoint(), 6);
		var target = inRange.find((e) ->
		{
			return e.has(Health) && factions.areEntitiesHostile(e, entity) && Game.instance.world.systems.vision.canSee(entity, e.pos);
		});

		if (target.isNull())
		{
			return false;
		}

		var shot = new ShootEvent(target.pos.toIntPoint(), entity);
		entity.fireEvent(shot);
		return shot.isHandled;
	}

	public function tryAttackingNearby(entity:Entity):Bool
	{
		var factions = Game.instance.world.factions;
		var neighbors = Game.instance.world.getNeighborEntities(entity.pos.toIntPoint());
		var target = neighbors.flatten().find((e) -> factions.areEntitiesHostile(e, entity));

		if (target.isNull())
		{
			return false;
		}

		var melee = new MeleeEvent(target, entity);
		entity.fireEvent(melee);
		return melee.isHandled;
	}
}
