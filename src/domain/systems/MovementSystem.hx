package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import domain.components.Move;
import domain.components.MoveComplete;
import domain.components.Moved;
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
			none: [MoveComplete]
		});
		completed = new Query({
			all: [MoveComplete]
		});
		moved = new Query({
			all: [Moved]
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
			entity.pos = move.goal;
			entity.remove(move);
			entity.add(new MoveComplete());
			return true;
		}
		return false;
	}

	public override function update(frame:Frame)
	{
		for (entity in completed)
		{
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

			var deltaSq = delta.lengthSq();
			var distanceSq = start.distanceSq(move.goal, WORLD);

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