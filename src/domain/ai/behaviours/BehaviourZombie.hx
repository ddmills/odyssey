package domain.ai.behaviours;

import ecs.Entity;

class BehaviourZombie extends Behaviour
{
	override function takeAction(entity:Entity)
	{
		// try melee
		tryAttackingNearby(entity);

		wait(entity);
	}
}
