package domain.components;

import domain.events.MovedEvent;
import ecs.Component;
import ecs.Entity;

class IsEquipped extends Component
{
	@save private var holderId:String;

	@save public var slotKey(default, null):String;
	@save public var extraSlotKey(default, null):String;

	public var holder(get, set):Null<Entity>;
	public var slot(get, never):EquipmentSlot;
	public var extraSlot(get, never):EquipmentSlot;
	public var slotDisplay(get, never):String;

	public function new(holderId:String, slotKey:String, ?extraSlotKey:String)
	{
		this.holderId = holderId;
		this.slotKey = slotKey;
		this.extraSlotKey = extraSlotKey;
		addHandler(MovedEvent, (evt) -> onMoved(cast evt));
	}

	function onMoved(evt:MovedEvent)
	{
		if (evt.mover.id != entity.id)
		{
			entity.pos = evt.pos;
		}
	}

	function get_holder():Null<Entity>
	{
		return entity.registry.getEntity(holderId);
	}

	function set_holder(value:Entity):Entity
	{
		holderId = value.id;

		return value;
	}

	function get_slot():EquipmentSlot
	{
		return holder.getAll(EquipmentSlot).find((s) -> s.slotKey == slotKey);
	}

	function get_extraSlot():EquipmentSlot
	{
		return holder.getAll(EquipmentSlot).find((s) -> s.slotKey == extraSlotKey);
	}

	function get_slotDisplay():String
	{
		if (extraSlot != null)
		{
			return '[${slot.name}, ${extraSlot.name}]';
		}
		return '[${slot.name}]';
	}
}
