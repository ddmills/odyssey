package domain.components;

import domain.events.QueryInteractionsEvent;
import domain.events.ThrowEvent;
import ecs.Component;

class Throwable extends Component
{
	public function new()
	{
		addHandler(QueryInteractionsEvent, onQueryInteractions);
		addHandler(ThrowEvent, onThrow);
	}

	public function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		evt.add({
			name: 'Throw',
			evt: new ThrowEvent(evt.interactor),
		});
	}

	public function onThrow(evt:ThrowEvent)
	{
		trace('throw me!');
	}
}
