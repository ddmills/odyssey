package domain.components;

import core.Game;
import data.EquipmentSlotType;
import domain.events.QueryInteractionsEvent;
import domain.events.TryEquipEvent;
import domain.events.TryUnequipEvent;
import ecs.Component;
import screens.listSelect.ListSelectScreen;

class Equipment extends Component
{
	public var slotTypes:Array<EquipmentSlotType>;

	public function new(slotTypes:Array<EquipmentSlotType>)
	{
		this.slotTypes = slotTypes;
		addHandler(QueryInteractionsEvent, (evt) -> onQueryInteractions(cast evt));
		addHandler(TryEquipEvent, (evt) -> onTryEquip(cast evt));
		addHandler(TryUnequipEvent, (evt) -> onTryUnequip(cast evt));
	}

	public function onTryEquip(evt:TryEquipEvent)
	{
		var slots = evt.equipper.getAll(EquipmentSlot).filter((s) ->
		{
			return slotTypes.contains(s.slotType);
		});

		var rows:Array<ListItem> = slots.map((slot) ->
		{
			return {
				title: slot.name,
				getIcon: () -> null,
				onSelect: () ->
				{
					slot.unequip();
					slot.equip(entity);
					Game.instance.screens.pop();
				},
			};
		});

		var screen = new ListSelectScreen(rows);

		Game.instance.screens.push(screen);
	}

	public function onTryUnequip(evt:TryUnequipEvent)
	{
		var equipped = entity.get(IsEquipped);
		var slot = equipped.holder.getAll(EquipmentSlot).find((s) -> s.slotKey == equipped.slotKey);

		if (slot != null)
		{
			slot.unequip();
		}
	}

	public function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		if (entity.has(IsEquipped))
		{
			evt.add({
				name: 'Unequip',
				evt: new TryUnequipEvent(evt.interactor),
			});
		}
		else
		{
			evt.add({
				name: 'Equip',
				evt: new TryEquipEvent(evt.interactor),
			});
		}
	}
}
