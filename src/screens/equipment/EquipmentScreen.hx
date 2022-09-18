package screens.equipment;

import core.Screen;
import domain.components.EquipmentSlot;
import domain.components.Sprite;
import ecs.Entity;
import h2d.Bitmap;
import screens.interaction.InteractionScreen;
import screens.listSelect.ListSelectScreen;

class EquipmentScreen extends ListSelectScreen
{
	public var target:Entity;

	public function new(target:Entity)
	{
		this.target = target;
		super([]);
		title = 'Equipment';
		cancelText = 'Back';
	}

	function refreshList()
	{
		var items = target.getAll(EquipmentSlot).map(makeListItem);

		setItems(items);
	}

	override function onResume()
	{
		super.onResume();
		refreshList();
	}

	override function onEnter()
	{
		super.onEnter();
		refreshList();
	}

	function makeListItem(slot:EquipmentSlot):ListItem
	{
		return {
			title: slot.name,
			detail: '[${slot.contentDisplay}]',
			getIcon: () ->
			{
				var bm = new Bitmap();
				if (slot.content == null)
				{
					bm.visible = false;
					return bm;
				}

				return slot.content.get(Sprite).getBitmapClone();
			},
			onSelect: () ->
			{
				if (!slot.isEmpty)
				{
					showInteractions(slot.content);
				}
			}
		};
	}

	private function showInteractions(e:Entity)
	{
		var interactionScreen = new InteractionScreen(e, target);
		interactionScreen.onClosedlistener = () ->
		{
			refreshList();
		};
		interactionScreen.cancelText = 'Back';
		game.screens.push(interactionScreen);
	}
}
