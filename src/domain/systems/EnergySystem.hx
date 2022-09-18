package domain.systems;

import core.Frame;
import data.EnergyActionType;
import domain.components.Bullet;
import domain.components.Energy;
import domain.components.IsPlayer;
import domain.components.Moniker;
import domain.events.ConsumeEnergyEvent;
import domain.skills.Skills;
import ecs.Entity;
import ecs.Query;
import ecs.System;

class EnergySystem extends System
{
	public var isPlayersTurn(default, null):Bool;

	var query:Query;
	var bullets:Query;

	public function new()
	{
		isPlayersTurn = false;
		query = new Query({
			all: [Energy]
		});
		bullets = new Query({
			all: [Bullet]
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
			return;
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
			var speed = Skills.GetValue(SKILL_SPEED, entity);

			return 80 - (speed * 5);
		}

		if (type == ACT_WAIT)
		{
			return 50;
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
