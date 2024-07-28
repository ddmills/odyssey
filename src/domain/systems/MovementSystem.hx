package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
import domain.components.Move;
import domain.components.MoveComplete;
import domain.components.Moved;
import ecs.Entity;
import ecs.Query;
import ecs.System;

class MovementSystem extends System
{
	var movers:Query;
	var moved:Query;
	var completed:Query;

	public function new()
	{
		movers = new Query({
			all: [Move],
			none: [MoveComplete, IsDestroyed, IsInventoried]
		});

		movers.onEntityAdded((e) ->
		{
			var move = e.get(Move);

			move.start = e.drawable.pos == null ? e.pos : e.drawable.pos;
			move.startTime = game.frame.elapsed;

			if (e.drawable.pos == null)
			{
				e.drawable.pos = e.pos;
			}

			e.pos = move.goal;
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

	public function finishMoveFast(entity:Entity):Bool
	{
		var move = entity.get(Move);

		if (move == null)
		{
			return false;
		}

		move.duration = .015;

		return true;
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
			var move = entity.get(Move);

			if (!move.isMovedFired)
			{
				entity.add(new Moved());
				move.isMovedFired = true;
			}

			if (entity.drawable.pos == null)
			{
				entity.drawable.pos = move.start;

				if (move.start == null)
				{
					trace('move start is null?!', move.start);
				}
			}

			var current = entity.drawable.pos.toWorld();
			var distanceSq = current.distance(move.goal, WORLD, EUCLIDEAN_SQ);

			var currentDuration = frame.elapsed - move.startTime;
			var progress = (currentDuration / move.duration).clamp(0, 1);

			var newPos = move.start.ease(move.goal, progress, move.ease);

			entity.drawable.pos = newPos;

			if (distanceSq < move.epsilon * move.epsilon)
			{
				entity.drawable.pos = null;
				entity.remove(move);
				entity.add(new MoveComplete());
			}
		}
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
}
