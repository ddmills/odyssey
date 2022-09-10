package domain.components;

import core.Game;
import data.AudioKey;
import data.EquipmentSlotType;
import domain.events.DropEvent;
import domain.events.EquipEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.TakeEvent;
import domain.events.UnequipEvent;
import ecs.Component;
import hxd.res.Sound;
import screens.listSelect.ListSelectScreen;

class Equipment extends Component
{
	@save public var slotTypes:Array<EquipmentSlotType> = [];
	@save public var extraSlotTypes:Array<EquipmentSlotType> = [];

	public var equipAudio:AudioKey = LOOT_PICKUP_1;
	public var unequipAudio:AudioKey = LOOT_DROP_1;

	public function new(slotTypes:Array<EquipmentSlotType>, ?extraSlotTypes:Array<EquipmentSlotType>)
	{
		this.slotTypes = slotTypes;
		this.extraSlotTypes = extraSlotTypes == null ? [] : extraSlotTypes;

		addHandler(QueryInteractionsEvent, (evt) -> onQueryInteractions(cast evt));
		addHandler(EquipEvent, (evt) -> onEquip(cast evt));
		addHandler(UnequipEvent, (evt) -> onUnequip(cast evt));
		addHandler(DropEvent, (evt) -> onDrop(cast evt));
		addHandler(TakeEvent, (evt) -> onTake(cast evt));
	}

	public function unequip()
	{
		var equipped = entity.get(IsEquipped);

		if (equipped == null)
		{
			return;
		}

		var slot = equipped.holder.getAll(EquipmentSlot).find((s) -> s.slotKey == equipped.slotKey);

		if (slot != null)
		{
			slot.unequip();
		}
	}

	private function onEquip(evt:EquipEvent)
	{
		var slots = evt.equipper.getAll(EquipmentSlot).filter((s) ->
		{
			return slotTypes.contains(s.slotType);
		});

		var slots:Array<ListItem> = slots.map((slot) -> ({
			title: slot.displayName,
			detail: null,
			getIcon: null,
			onSelect: () ->
			{
				slot.unequip();
				slot.equip(entity);
				Game.instance.audio.play(equipAudio);
				Game.instance.screens.pop();
			},
		}));
		var screen = new ListSelectScreen(slots);

		screen.title = 'Equip ${entity.get(Moniker).displayName}';

		Game.instance.screens.push(screen);
	}

	private function onUnequip(evt:UnequipEvent)
	{
		unequip();
		Game.instance.audio.play(unequipAudio);
	}

	private function onDrop(evt:DropEvent)
	{
		unequip();
	}

	private function onTake(evt:TakeEvent)
	{
		unequip();
	}

	private function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		if (entity.has(IsEquipped))
		{
			evt.add({
				name: 'Unequip',
				evt: new UnequipEvent(evt.interactor),
			});
		}
		else
		{
			evt.add({
				name: 'Equip',
				evt: new EquipEvent(evt.interactor),
			});
		}
	}
}
