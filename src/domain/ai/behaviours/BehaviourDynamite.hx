package domain.ai.behaviours;

import domain.components.Explosive;
import domain.systems.EnergySystem;
import ecs.Entity;

class BehaviourDynamite extends Behaviour
{
	override function takeAction(entity:Entity)
	{
		if (tryExploding(entity))
		{
			return;
		}

		wait(entity);
	}

	public function tryExploding(entity:Entity):Bool
	{
		var explosive = entity.get(Explosive);

		if (explosive == null || !explosive.isFuseLit)
		{
			return false;
		}

		var cost = EnergySystem.ConsumeEnergy(entity, ACT_FUSE_TICK);

		explosive.onTickDelta(cost);

		return true;
	}
}
