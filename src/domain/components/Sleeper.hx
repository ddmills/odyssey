package domain.components;

import domain.events.SleepEvent;
import ecs.Component;

class Sleeper extends Component
{
	public function new()
	{
		addHandler(SleepEvent, onSleep);
	}

	private function onSleep(evt:SleepEvent)
	{
		var duration = Clock.TICKS_PER_HOUR * 4;
		entity.add(new IsSleeping(duration));
	}
}
