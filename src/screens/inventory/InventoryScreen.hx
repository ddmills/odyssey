package screens.inventory;

import domain.components.Inventory;
import domain.components.Moniker;
import ecs.Entity;
import screens.entitySelect.EntitySelectScreen;
import screens.interaction.InteractionScreen;

class InventoryScreen extends EntitySelectScreen
{
	private var accessor:Entity;
	private var accessible:Entity;

	public function new(accessor:Entity, accessible:Entity)
	{
		this.accessor = accessor;
		this.accessible = accessible;

		this.onSelect = (e) ->
		{
			var interactionScreen = new InteractionScreen(e, this.accessor);
			interactionScreen.onClosedlistener = () ->
			{
				refreshList();
			};
			interactionScreen.cancelText = 'Back';
			game.screens.push(interactionScreen);
		};

		super(accessible.get(Inventory).content);
		cancelText = 'Back';

		fetchEntities = () -> accessible.get(Inventory).content;

		title = '${accessible.get(Moniker).displayName} Inventory';
	}
}
