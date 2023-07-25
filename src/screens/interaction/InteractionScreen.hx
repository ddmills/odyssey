package screens.interaction;

import core.Frame;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
import domain.components.Moniker;
import domain.events.QueryInteractionsEvent;
import ecs.Entity;
import screens.listSelect.ListSelectScreen;

class InteractionScreen extends ListSelectScreen
{
	var interactor:Entity;
	var interactable:Entity;

	public function new(interactable:Entity, interactor:Entity)
	{
		this.inputDomain = INPUT_DOMAIN_DEFAULT;
		this.interactable = interactable;
		this.interactor = interactor;
		super([]);
		cancelText = 'Back';
		refreshList();
	}

	public function refreshList()
	{
		title = interactable.get(Moniker).displayName;

		if (interactable.has(IsInventoried))
		{
			targetPos = interactable.get(IsInventoried).holder.pos;
		}
		else
		{
			targetPos = interactable.pos;
		}

		var evt = new QueryInteractionsEvent(interactor);
		interactable.fireEvent(evt);
		var items = evt.interactions.map((action) -> ({
			title: action.name,
			detail: null,
			getIcon: null,
			onSelect: () ->
			{
				if (action.popScreen)
				{
					game.screens.pop();
				}

				interactable.fireEvent(action.evt);
				refreshList();

				if (interactable.has(IsDestroyed))
				{
					game.screens.pop();
				}

				return;
			},
		}));

		setItems(items);
	}

	override function onResume()
	{
		super.onResume();
		refreshList();
	}

	override function update(frame:Frame)
	{
		super.update(frame);
		world.updateSystems();
	}
}
