package domain.components;

import common.struct.Coordinate;
import core.Game;
import data.Cardinal;
import data.SpawnableType;
import domain.events.AttackedEvent;
import domain.events.SpawnedEvent;
import domain.prefabs.Spawner;
import domain.skills.Skills;
import ecs.Component;
import hxd.Rand;

class Health extends Component
{
	public var value(default, set):Int = 10;
	public var max(get, never):Int;
	public var corpsePrefab:SpawnableType;

	public function new()
	{
		addHandler(SpawnedEvent, (evt) -> onSpawned(cast evt));
		addHandler(AttackedEvent, (evt) -> onAttacked(cast evt));
	}

	public function get_max():Int
	{
		var skill = Skills.GetValue(SKILL_FORTITUDE, entity);
		var level = 0;

		return 10 + level * 10 + skill * 10;
	}

	public function toString():String
	{
		return '$value/$max';
	}

	private function onSpawned(evt:SpawnedEvent)
	{
		value = max;
	}

	private function onAttacked(evt:AttackedEvent)
	{
		var r = Rand.create();
		var dodge = Skills.GetValue(SKILL_DODGE, entity);
		var ac = r.roll(Game.instance.DIE_SIZE, dodge);

		if (evt.attack.isCritical)
		{
			ac = 0;
		}

		if (evt.attack.toHit >= ac)
		{
			value -= evt.attack.damage;
			makeBloodEffect(evt.attack.attacker.pos);
			evt.isHit = true;
		}
		else
		{
			evt.isHit = false;
		}
	}

	private function makeBloodEffect(source:Coordinate)
	{
		var degrees = entity.pos.sub(source).angle().toDegrees();
		var cardinal = Cardinal.fromDegrees(degrees);
		var spot = cardinal.toOffset().asWorld().floor();
		Spawner.Spawn(BLOOD_SPATTER, entity.pos.floor().add(spot));
	}

	public function set_value(value:Int):Int
	{
		this.value = value.clamp(0, max);

		if (this.value <= 0)
		{
			entity.add(new IsDead());
		}

		return this.value;
	}
}
