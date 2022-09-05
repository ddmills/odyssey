package screens.interaction;

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
		title = interactable.get(Moniker).displayName;
		refreshList();
	}

	public function refreshList()
	{
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
				interactable.fireEvent(action.evt);
				refreshList();
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
}
