package domain.components;

import domain.events.AttackedEvent;
import domain.events.SpawnedEvent;
import domain.skills.Skills;
import ecs.Component;
import hxd.Rand;

class Health extends Component
{
	public var value(default, set):Int = 10;
	public var max(get, never):Int;

	public function new()
	{
		addHandler(SpawnedEvent, (evt) -> onSpawned(cast evt));
		addHandler(AttackedEvent, (evt) -> onAttacked(cast evt));
	}

	public function get_max():Int
	{
		var skill = Skills.getValue(SKILL_MAX_HEALTH, entity);
		var level = 0;

		return 10 + level * 10 + skill * 10;
	}

	private function onSpawned(evt:SpawnedEvent)
	{
		value = max;
	}

	private function onAttacked(evt:AttackedEvent)
	{
		var r = Rand.create();
		var dodge = Skills.getValue(SKILL_DODGE, entity);
		var ac = r.roll(6, dodge);

		if (evt.attack.isCritical)
		{
			ac = 0;
		}

		var critTxt = evt.attack.isCritical ? '!' : '';
		trace('attack (${evt.attack.damage}${critTxt}) ${evt.attack.toHit} >= $ac');
		if (evt.attack.toHit >= ac)
		{
			value -= evt.attack.damage;
			trace('HP $value/$max');
		}
	}

	function set_value(value:Int):Int
	{
		this.value = value.clamp(0, max);

		if (this.value <= 0)
		{
			entity.add(new IsDead());
		}

		return this.value;
	}
}
