package domain;

import core.Game;
import data.Cardinal;
import domain.ai.behaviours.Behaviours;
import domain.components.Actor;
import domain.components.Collider;
import domain.components.Explosive;
import domain.components.Health;
import domain.components.IsEnemy;
import domain.components.IsPlayer;
import domain.components.Move;
import domain.events.MeleeEvent;
import domain.events.ReloadEvent;
import domain.events.ShootEvent;
import domain.systems.EnergySystem;
import ecs.Entity;
import hxd.Rand;

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
