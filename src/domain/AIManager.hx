package domain;

import core.Game;
import data.Cardinal;
import domain.components.Collider;
import domain.components.Health;
import domain.components.Move;
import domain.events.MeleeEvent;
import domain.events.ReloadEvent;
import domain.events.ShootEvent;
import domain.systems.EnergySystem;
import ecs.Entity;
import hxd.Rand;

class AIManager
{
	var rand:Rand;

	public function new()
	{
		rand = new Rand(4);
	}

	public function takeAction(entity:Entity)
	{
		Game.instance.world.systems.movement.finishMoveFast(entity);

		if (tryAttackingNearby(entity))
		{
			return;
		}

		if (tryAttackingRange(entity))
		{
			return;
		}

		if (tryReloading(entity))
		{
			return;
		}

		if (tryMove(entity))
		{
			return;
		}

		EnergySystem.ConsumeEnergy(entity, ACT_WAIT);
	}

	public function tryMove(entity:Entity):Bool
	{
		var delta = rand.pick(Cardinal.values).toOffset();
		var goal = entity.pos.add(delta.asWorld()).ciel();

		var chunkIdx = goal.toChunkIdx();
		var chunk = Game.instance.world.chunks.getChunkById(chunkIdx);

		if (!chunk.isLoaded)
		{
			return false;
		}

		if (Game.instance.world.getEntitiesAt(goal).exists((e) -> e.has(Collider)))
		{
			return false;
		}

		EnergySystem.ConsumeEnergy(entity, ACT_MOVE);

		entity.add(new Move(goal, .5, LINEAR));
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
