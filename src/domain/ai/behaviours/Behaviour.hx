package domain.ai.behaviours;

import common.algorithm.AStar;
import common.algorithm.Distance;
import common.struct.Coordinate;
import core.Game;
import domain.components.Collider;
import domain.components.Health;
import domain.components.IsEnemy;
import domain.components.Move;
import domain.components.Vision;
import domain.components.Weapon;
import domain.events.MeleeEvent;
import domain.events.QueryEquippedWeaponsEvent;
import domain.events.ReloadEvent;
import domain.events.ShootEvent;
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
		var vision = entity.get(Vision);

		if (vision == null)
		{
			return [];
		}

		var inRange = Game.instance.world.getEntitiesInRange(entity.pos.toIntPoint(), vision.range);
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

	public function tryReloading(entity:Entity, weapon:Weapon):Bool
	{
		if (weapon.isLoaded)
		{
			return false;
		}

		var reload = new ReloadEvent(entity);
		entity.fireEvent(reload);
		return reload.isHandled;
	}

	public function tryAttackingRange(entity:Entity, target:Entity, weapon:Weapon):Bool
	{
		if (weapon == null)
		{
			return false;
		}

		var dist = GameMath.GetTargetDistance(entity.pos.toIntPoint(), target.pos.toIntPoint());

		if (dist > weapon.range)
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

	public function getPrimaryRangeWeapon(entity:Entity):Weapon
	{
		var evt = entity.fireEvent(new QueryEquippedWeaponsEvent());
		var w = evt.getPrimaryRanged();

		if (w == null)
		{
			return null;
		}

		return w.weapon;
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