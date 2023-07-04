package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
import domain.components.IsPlayer;
import domain.components.Move;
import domain.components.MoveComplete;
import domain.components.Moved;
import domain.components.Sprite;
import domain.events.ConsumeEnergyEvent;
import ecs.Entity;
import ecs.Query;
import ecs.System;

class MovementSystem extends System
{
	var movers:Query;
	var completed:Query;
	var moved:Query;

	public function new()
	{
		movers = new Query({
			all: [Move],
			none: [MoveComplete, IsDestroyed, IsInventoried]
		});
		completed = new Query({
			all: [MoveComplete],
			none: [IsDestroyed],
		});
		moved = new Query({
			all: [Moved],
			none: [IsDestroyed],
		});
	}

	inline function getDelta(pos:Coordinate, goal:Coordinate, speed:Float, tween:Tween, tmod:Float):Coordinate
	{
		switch tween
		{
			case LINEAR:
				var direction = pos.direction(goal);
				var dx = direction.x * tmod * speed;
				var dy = direction.y * tmod * speed;
				return new Coordinate(dx, dy, WORLD);
			case LERP:
				return pos.lerp(goal, tmod * speed).sub(pos);
			case INSTANT:
				return goal.sub(pos);
		}
	}

	public function finishMoveFast(entity:Entity):Bool
	{
		var move = entity.get(Move);
		if (move != null)
		{
			entity.remove(Move);

			if (entity.x.floor() != move.goal.x.floor() || entity.y.floor() != move.goal.y.floor())
			{
				entity.add(new Moved());
			}

			entity.pos = move.goal;
			entity.add(new MoveComplete());
			return true;
		}
		return false;
	}

	public override function update(frame:Frame)
	{
		for (entity in completed)
		{
			if (entity.has(IsPlayer))
			{
				var cost = EnergySystem.GetEnergyCost(entity, ACT_MOVE);
				entity.fireEvent(new ConsumeEnergyEvent(cost));
			}
			entity.remove(MoveComplete);
		}
		for (entity in moved)
		{
			entity.remove(Moved);
		}

		for (entity in movers)
		{
			var start = entity.pos;
			var move = entity.get(Move);

			var delta = getDelta(start, move.goal, move.speed, move.tween, frame.tmod);

			if (entity.has(Sprite))
			{
				entity.get(Sprite).background = null;
			}

			var deltaSq = delta.lengthSq();
			var distanceSq = start.distance(move.goal, WORLD, EUCLIDEAN_SQ);

			start.lerp(move.goal, frame.tmod * move.speed);

			if (distanceSq < Math.max(deltaSq, move.epsilon * move.epsilon))
			{
				entity.pos = move.goal;
				entity.remove(move);
				entity.add(new MoveComplete());
			}
			else
			{
				entity.pos = start.add(delta);
			}

			if (entity.x.floor() != start.x.floor() || entity.y.floor() != start.y.floor())
			{
				entity.add(new Moved());
			}
		}
	}
}
