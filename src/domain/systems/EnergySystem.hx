package domain.systems;

import core.Frame;
import data.EnergyActionType;
import domain.components.Bullet;
import domain.components.Energy;
import domain.components.IsPlayer;
import domain.components.Move;
import domain.components.Stats;
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
		var entities = query.toArray();
		var entity = entities.max((e) -> e.get(Energy).value);
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

		entities.remove(entity);

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
			else if (bullets.size > 0 && !game.commands.hasNext())
			{
				isPlayersTurn = false;
				break;
			}
			else
			{
				isPlayersTurn = false;
				world.ai.takeAction(entity);
			}
		}
	}

	public static function getEnergyCost(entity:Entity, type:EnergyActionType):Int
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

		return 50;
	}
}
