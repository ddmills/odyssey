package domain;

import common.struct.IntPoint;
import core.Game;
import domain.components.Energy;
import domain.components.Move;
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

		var delta:IntPoint = {
			x: rand.pick([-1, 0, 1]),
			y: rand.pick([-1, 0, 1]),
		};

		var goal = entity.pos.add(delta.asWorld()).ciel();

		entity.add(new Move(goal, .1, LINEAR));
		entity.get(Energy).consumeEnergy(75);
	}
}
