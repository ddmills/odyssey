package screens.interaction;

import common.algorithm.Distance.DistanceFormula;
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
		if (isOutOfReach())
		{
			trace('is out of reach');
			game.screens.pop();
			return;
		}

		title = interactable.get(Moniker)?.displayName ?? 'Unknown';

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
					trace('pop screen');
					game.screens.pop();
				}

				interactable.fireEvent(action.evt);
				refreshList();

				return;
			},
		}));
		setItems(items);
	}

	function isOutOfReach()
	{
		if (interactable.isDestroyed || interactable.has(IsDestroyed))
		{
			trace('is destroyed');
			return true;
		}

		var distance = interactable.pos.distance(interactor.pos, DistanceFormula.CHEBYSHEV);

		return distance > 1;
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
