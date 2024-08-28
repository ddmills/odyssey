package domain.ai.behaviours;

import common.algorithm.AStar;
import common.algorithm.Distance;
import common.struct.Coordinate;
import core.Game;
import domain.components.Collider;
import domain.components.Health;
import domain.components.IsEnemy;
import domain.components.Move;
import domain.systems.EnergySystem;
import ecs.Entity;
import hxd.Rand;

class Behaviour
{
	var r:Rand;
	var game(get, null):Game;
	var world(get, null):World;

	public function new()
	{
		r = new Rand(4);
	}

	public function takeAction(entity:Entity)
	{
		wait(entity);
	}

	public function wait(entity:Entity)
	{
		EnergySystem.ConsumeEnergy(entity, ACT_WAIT);
	}

	public function getVisibleTargets(entity:Entity):Array<Entity>
	{
		var factions = Game.instance.world.factions;
		var inRange = Game.instance.world.getEntitiesInRange(entity.pos.toIntPoint(), 6);
		var targets = inRange.filter((e) ->
		{
			return e.has(Health) && factions.areEntitiesHostile(e, entity) && Game.instance.world.systems.vision.canSee(entity, e.pos);
		});

		return targets;
	}

	public function tryMoveToward(entity:Entity, goal:Coordinate):Bool
	{
		var path = astar(entity, goal);

		if (!path.success)
		{
			return false;
		}

		var next = path.path[1];

		if (next == null)
		{
			return false;
		}

		EnergySystem.ConsumeEnergy(entity, ACT_MOVE);

		var fast = entity.has(Move);
		entity.add(new Move(next.asWorld(), fast ? .1 : .2, EASE_LINEAR));

		return true;
	}

	public function astar(entity:Entity, goal:Coordinate):AStarResult
	{
		return AStar.GetPath({
			start: entity.pos.toWorld().toIntPoint(),
			goal: goal.toWorld().toIntPoint(),
			maxDepth: 500,
			allowDiagonals: true,
			cost: (a, b) ->
			{
				if (world.isOutOfBounds(b))
				{
					return Math.POSITIVE_INFINITY;
				}

				var entities = world.getEntitiesAt(b);

				if (entities.exists((e) -> e.has(Collider) || e.has(IsEnemy)))
				{
					return Math.POSITIVE_INFINITY;
				}

				return Distance.Diagonal(a, b);
			}
		});
	}

	inline function get_game():Game
	{
		return Game.instance;
	}

	inline function get_world():World
	{
		return Game.instance.world;
	}
}
