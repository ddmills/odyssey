package domain;

import common.struct.IntPoint;
import core.Game;
import data.Cardinal;
import domain.components.Energy;
import domain.components.Health;
import domain.components.Move;
import domain.events.MeleeEvent;
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

		var delta = rand.pick(Cardinal.values).toOffset();
		var goal = entity.pos.add(delta.asWorld()).ciel();

		entity.add(new Move(goal, .1, LINEAR));

		var cost = EnergySystem.getEnergyCost(entity, ACT_MOVE);

		entity.get(Energy).consumeEnergy(cost);
	}

	public function tryAttackingNearby(entity:Entity):Bool
	{
		var neighbors = Game.instance.world.getNeighborEntities(entity.pos.toIntPoint());
		var target = neighbors.flatten().find((e) -> e.has(Health));

		if (target == null)
		{
			return false;
		}

		var melee = new MeleeEvent(target, entity);
		entity.fireEvent(melee);
		return melee.isHandled;
	}
}
