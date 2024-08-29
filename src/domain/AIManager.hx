package domain;

import domain.ai.behaviours.Behaviours;
import domain.components.Actor;
import domain.systems.EnergySystem;
import ecs.Entity;

class AIManager
{
	public function new() {}

	public function takeAction(entity:Entity)
	{
		var actor = entity.get(Actor);

		if (actor == null)
		{
			trace('Energy without Actor component!');
			EnergySystem.ConsumeEnergy(entity, ACT_WAIT);
		}

		var behaviour = Behaviours.Get(actor.behaviour);
		behaviour.takeAction(entity);
	}
}
