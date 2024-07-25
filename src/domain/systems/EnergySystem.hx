package domain.systems;

import core.Frame;
import data.EnergyActionType;
import domain.components.Energy;
import domain.components.IsDead;
import domain.components.IsDestroyed;
import domain.components.IsDetached;
import domain.components.IsPlayer;
import domain.components.IsSleeping;
import domain.events.ConsumeEnergyEvent;
import domain.stats.Stats;
import ecs.Entity;
import ecs.Query;
import ecs.System;

class EnergySystem extends System
{
	public var isPlayersTurn(default, null):Bool;

	var query:Query;

	public function new()
	{
		isPlayersTurn = false;
		query = new Query({
			all: [Energy],
			none: [IsDetached, IsDead, IsDestroyed],
		});
	}

	function getNext():Entity
	{
		var entity = query.max((e) -> e.get(Energy).value);

		if (entity == null)
		{
			return null;
		}

		var energy = entity.get(Energy);

		if (!energy.hasEnergy)
		{
			var tickAmount = -energy.value;
			world.clock.incrementTick(tickAmount);
			query.each((e) -> e.get(Energy).addEnergy(tickAmount));
		}

		return entity;
	}

	override function update(frame:Frame)
	{
		world.clock.clearDeltas();
		if (isPlayersTurn && world.player.entity.get(Energy).hasEnergy)
		{
			var sleeping = world.player.entity.get(IsSleeping);
			if (sleeping != null)
			{
				if (sleeping.ticksRemaining > 0)
				{
					EnergySystem.ConsumeEnergy(world.player.entity, ACT_WAIT);
				}
			}
			else
			{
				return;
			}
		}

		while (true)
		{
			var entity = getNext();

			if (entity.has(IsPlayer))
			{
				isPlayersTurn = true;
				break;
			}
			else
			{
				isPlayersTurn = false;
				world.ai.takeAction(entity);
			}
		}
	}

	public static function ConsumeEnergy(entity:Entity, type:EnergyActionType)
	{
		var cost = GetEnergyCost(entity, type);
		entity.fireEvent(new ConsumeEnergyEvent(cost));
	}

	public static function GetEnergyCost(entity:Entity, type:EnergyActionType):Int
	{
		if (type == ACT_MOVE)
		{
			var speed = Stats.GetValue(STAT_SPEED, entity);

			return 80 - (speed * 5);
		}

		if (type == ACT_SLEEP)
		{
			return 1000;
		}

		if (type == ACT_WAIT)
		{
			return 500;
		}

		if (type == ACT_DROP)
		{
			return 25;
		}

		if (type == ACT_PICKUP || type == ACT_TAKE)
		{
			return 65;
		}

		if (type == ACT_EXTINGUISH)
		{
			return 25;
		}

		if (type == ACT_LIGHT)
		{
			return 150;
		}

		if (type == ACT_EQUIP || type == ACT_UNEQUIP)
		{
			return 80;
		}

		return 50;
	}
}
