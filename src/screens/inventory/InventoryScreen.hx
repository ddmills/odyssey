package screens.inventory;

import domain.components.Inventory;
import domain.components.Moniker;
import domain.events.GetInteractionsEvent;
import ecs.Entity;
import screens.entitySelect.EntitySelectScreen;
import screens.listSelect.ListSelectScreen;

class InventoryScreen extends EntitySelectScreen
{
	private var accessor:Entity;
	private var accessible:Entity;

	public function new(accessor:Entity, accessible:Entity)
	{
		this.accessor = accessor;
		this.accessible = accessible;

		this.onSelect = (e) -> showInteractions(e);

		var inventory = accessible.get(Inventory);
		super(inventory.content);

		title = '${accessible.get(Moniker).displayName} Inventory';
	}

	function showInteractions(entity:Entity)
	{
		var evt = new GetInteractionsEvent(accessor);
		entity.fireEvent(evt);

		var items = evt.interactions.map((action) -> ({
			title: action.name,
			onSelect: () ->
			{
				game.screens.pop();
				entity.fireEvent(action.evt);
				return;
			},
			getIcon: () -> null,
		}));

		var s = new ListSelectScreen(items);
		s.cancelText = 'Back';
		s.title = entity.get(Moniker).displayName;
		game.screens.push(s);
	}
}
