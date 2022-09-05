package domain.components;

import ecs.Component;
import ecs.Entity;

class IsEquipped extends Component
{
	private var _holderId:String;

	public var holder(get, set):Null<Entity>;
	public var slot(get, never):EquipmentSlot;
	public var extraSlot(get, never):EquipmentSlot;
	public var slotKey(default, null):String;
	public var extraSlotKey(default, null):String;
	public var slotDisplay(get, never):String;

	public function new(holderId:String, slotKey:String, ?extraSlotKey:String)
	{
		_holderId = holderId;
		this.slotKey = slotKey;
		this.extraSlotKey = extraSlotKey;
	}

	function get_holder():Null<Entity>
	{
		return entity.registry.getEntity(_holderId);
	}

	function set_holder(value:Entity):Entity
	{
		_holderId = value.id;

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
