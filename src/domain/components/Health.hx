package domain.components;

import domain.events.SpawnedEvent;
import domain.skills.Skills;
import ecs.Component;

class Health extends Component
{
	public var value:Int = 10;
	public var max(get, never):Int;

	public function new()
	{
		addHandler(SpawnedEvent, (evt) -> onSpawned(cast evt));
	}

	public function get_max():Int
	{
		var skill = Skills.getValue(SKILL_MAX_HEALTH, entity);
		var level = 0;

		return 50 + level * 10 + skill * 10;
	}

	private function onSpawned(evt:SpawnedEvent)
	{
		trace(max);
		value = max;
	}
}
