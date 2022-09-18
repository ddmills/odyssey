package domain.components;

import core.Game;
import data.AudioKey;
import data.EquipmentSlotType;
import domain.events.ConsumeEnergyEvent;
import domain.events.DropEvent;
import domain.events.EquipEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.UnequipEvent;
import domain.systems.EnergySystem;
import ecs.Component;
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
				EnergySystem.ConsumeEnergy(evt.equipper, ACT_EQUIP);
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
		EnergySystem.ConsumeEnergy(evt.unequipper, ACT_UNEQUIP);
		unequip();
		Game.instance.audio.play(unequipAudio);
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
