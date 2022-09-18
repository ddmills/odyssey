package domain.components;

import common.struct.Coordinate;
import core.Game;
import data.Cardinal;
import data.SpawnableType;
import domain.events.AttackedEvent;
import domain.events.EnemyKilledEvent;
import domain.events.SpawnedEvent;
import domain.prefabs.Spawner;
import domain.skills.Skills;
import ecs.Component;
import hxd.Rand;

class Health extends Component
{
	@save private var _value:Int = 10;

	@save public var corpsePrefab:SpawnableType;

	public var value(get, set):Int;
	public var max(get, never):Int;

	public function new()
	{
		addHandler(SpawnedEvent, (evt) -> onSpawned(cast evt));
		addHandler(AttackedEvent, (evt) -> onAttacked(cast evt));
	}

	public function get_max():Int
	{
		var skill = Skills.GetValue(SKILL_FORTITUDE, entity);
		var lvlComp = entity.get(Level);
		var level = lvlComp == null ? 0 : lvlComp.level;

		return GameMath.GetMaxHealth(level, skill);
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
			entity.add(new HitBlink());
			evt.isHit = true;
		}
		else
		{
			evt.isHit = false;
		}

		if (_value <= 0)
		{
			evt.attack.attacker.fireEvent(new EnemyKilledEvent(entity));
		}
	}

	private function makeBloodEffect(source:Coordinate)
	{
		var cardinal = entity.pos.sub(source).cardinal();
		var spot = cardinal.toOffset().asWorld().floor();
		Spawner.Spawn(BLOOD_SPATTER, entity.pos.floor().add(spot));
	}

	public function set_value(value:Int):Int
	{
		_value = value.clamp(0, max);

		if (_value <= 0)
		{
			entity.add(new IsDead());
		}

		return _value;
	}

	inline function get_value():Int
	{
		return _value;
	}
}
