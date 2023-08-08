package domain.components;

import common.struct.Coordinate;
import core.Game;
import data.ColorKey;
import data.SpawnableType;
import domain.events.AttackedEvent;
import domain.events.DamagedEvent;
import domain.events.EnemyKilledEvent;
import domain.events.EntitySpawnedEvent;
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
	public var percent(get, never):Float;

	public function new()
	{
		addHandler(EntitySpawnedEvent, onEntitySpawned);
		addHandler(AttackedEvent, onAttacked);
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

	private function onEntitySpawned(evt:EntitySpawnedEvent)
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
			entity.fireEvent(new DamagedEvent());
			Spawner.Spawn(FLOATING_TEXT, entity.pos, {
				text: '-' + value.toString(),
				color: ColorKey.C_RED_3,
				speed: r.float(.3, 1),
			});
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
		Spawner.Spawn(BLOOD_SPURT, entity.pos.floor());
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

	function get_percent():Float
	{
		return value / max;
	}
}
