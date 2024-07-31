package domain.components;

import common.struct.Coordinate;
import core.Game;
import data.ColorKey;
import data.SpawnableType;
import domain.events.AttackedEvent;
import domain.events.DamagedEvent;
import domain.events.EnemyKilledEvent;
import domain.events.EntitySpawnedEvent;
import domain.events.HealEvent;
import domain.prefabs.Spawner;
import domain.stats.Stats;
import ecs.Component;
import hxd.Rand;

class Health extends Component
{
	@save private var _value:Int = 10;
	@save private var _armoveValue:Int = 10;

	@save public var regenDelayTicks:Int = 10;
	@save public var corpsePrefab:SpawnableType;

	public var value(get, set):Int;
	public var max(get, never):Int;
	public var percent(get, never):Float;

	public var armor(get, set):Int;
	public var armorMax(get, never):Int;
	public var armorPercent(get, never):Float;

	public function new()
	{
		addHandler(EntitySpawnedEvent, onEntitySpawned);
		addHandler(AttackedEvent, onAttacked);
		addHandler(HealEvent, onHeal);
	}

	public function toString():String
	{
		return '$value/$max ($armor/$armorMax)';
	}

	public function onTickDelta(tickDelta:Int)
	{
		regenDelayTicks -= tickDelta;

		if (armor < armorMax && regenDelayTicks <= 0)
		{
			regenDelayTicks = 0;

			var regenStat = Stats.GetValue(STAT_ARMOR_REGEN, entity);
			var rate = GameMath.GetArmorRegenRatePerTurn(regenStat) / 100;
			armor += (rate * tickDelta).round().clampLower(1);
		}
		else if (armor > armorMax)
		{
			armor = armorMax;
		}
	}

	private function onEntitySpawned(evt:EntitySpawnedEvent)
	{
		value = max;
		armor = armorMax;
	}

	private function takeDamage(amount:Int):Bool
	{
		var remaining = armor - amount;

		if (remaining >= 0)
		{
			armor = remaining;
			return false;
		}

		armor = 0;

		value += remaining;
		return true;
	}

	private function onHeal(evt:HealEvent)
	{
		value = max;
		armor = armorMax;
	}

	private function onAttacked(evt:AttackedEvent)
	{
		var r = Rand.create();
		var dodge = Stats.GetValue(STAT_DODGE, entity);
		var ac = r.roll(Game.instance.DIE_SIZE, dodge);

		if (evt.attack.isCritical)
		{
			ac = 0;
		}

		if (evt.attack.toHit >= ac)
		{
			var regenStat = Stats.GetValue(STAT_ARMOR_REGEN, entity);
			regenDelayTicks = GameMath.GetArmorRegenDelay(regenStat);

			if (takeDamage(evt.attack.damage))
			{
				makeBloodEffect(evt.attack.attacker.pos);
			}
			entity.add(new HitBlink());
			evt.isHit = true;
			entity.fireEvent(new DamagedEvent());

			if (evt.attack.isCritical)
			{
				Spawner.Spawn(FLOATING_TEXT, entity.pos, {
					text: 'crit! -' + evt.attack.damage.toString(),
					color: ColorKey.C_YELLOW_2,
					duration: 120
				});
			}
			else
			{
				Spawner.Spawn(FLOATING_TEXT, entity.pos, {
					text: '-' + evt.attack.damage.toString(),
					color: ColorKey.C_RED_2,
					duration: 100
				});
			}
		}
		else
		{
			Spawner.Spawn(FLOATING_TEXT, entity.pos, {
				text: 'dodged',
				color: ColorKey.C_BLUE_2,
				duration: 80
			});
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

	public function get_max():Int
	{
		var stat = Stats.GetValue(STAT_FORTITUDE, entity);
		var lvlComp = entity.get(Level);
		var level = lvlComp == null ? 0 : lvlComp.level;

		return GameMath.GetMaxHealth(level, stat);
	}

	function set_armor(value:Int):Int
	{
		_armoveValue = value.clamp(0, armorMax);

		return _armoveValue;
	}

	function get_armor():Int
	{
		return _armoveValue;
	}

	function get_armorPercent():Float
	{
		return _armoveValue / armorMax;
	}

	function get_armorMax():Int
	{
		var stat = Stats.GetValue(STAT_ARMOR, entity);
		var lvlComp = entity.get(Level);
		var level = lvlComp == null ? 0 : lvlComp.level;

		return GameMath.GetMaxArmor(level, stat);
	}
}
