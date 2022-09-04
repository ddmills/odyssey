package domain.components;

import domain.events.SpawnedEvent;
import ecs.Component;

class Health extends Component
{
	public var value:Int = 10;
	public var max(get, never):Int;

	public function new()
	{
		addHandler(SpawnedEvent, (evt) -> onSpawned(cast(evt)));
	}

	public function get_max():Int
	{
		var level = 0;
		var grit = Stats.Get(entity, GRIT);

		return 50 + level * 10 + grit * 10;
	}

	private function onSpawned(evt:SpawnedEvent)
	{
		trace('set hp', max);
		value = max;
	}
}
