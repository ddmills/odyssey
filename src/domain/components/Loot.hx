package domain.components;

import domain.events.DropEvent;
import domain.events.GetInteractionsEvent;
import domain.events.PickupEvent;
import ecs.Component;

class Loot extends Component
{
	public function new()
	{
		addHandler(GetInteractionsEvent, (evt) -> onGetInteractions(cast(evt, GetInteractionsEvent)));
		addHandler(PickupEvent, (evt) -> onPickup(cast(evt, PickupEvent)));
		addHandler(DropEvent, (evt) -> onDrop(cast(evt, DropEvent)));
	}

	private function onPickup(evt:PickupEvent)
	{
		// add item to inventory of evt.interactor
		trace('onPickup');
	}

	private function onDrop(evt:DropEvent)
	{
		// remove item from current inventory
		trace('onDrop');
	}

	private function onGetInteractions(evt:GetInteractionsEvent)
	{
		if (entity.has(IsInventoried))
		{
			evt.interactions.push({
				name: 'Drop',
				evt: new DropEvent(),
			});
		}
		else
		{
			evt.interactions.push({
				name: 'Pickup',
				evt: new PickupEvent(evt.interactor),
			});
		}
	}
}
