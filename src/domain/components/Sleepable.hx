package domain.components;

import domain.events.QueryInteractionsEvent;
import domain.events.SleepEvent;
import domain.events.SleepInitiateEvent;
import ecs.Component;

class Sleepable extends Component
{
	public function new()
	{
		addHandler(QueryInteractionsEvent, onQueryInteractions);
		addHandler(SleepInitiateEvent, onSleepInitiate);
	}

	private function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		if (!entity.has(IsInventoried))
		{
			evt.add({
				name: 'Sleep',
				evt: new SleepInitiateEvent(evt.interactor),
			});
		}
	}

	private function onSleepInitiate(evt:SleepInitiateEvent)
	{
		var sleeper = evt.sleeper;
		trace('Initiate sleeping');
		sleeper.fireEvent(new SleepEvent(entity));
	}
}
