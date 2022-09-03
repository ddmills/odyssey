package domain.components;

import data.EquipmentSlotType;
import ecs.Component;

class EquipmentSlot extends Component
{
	static var allowMultiple = true;

	public var name:String;
	public var slotKey:String;
	public var slotType:EquipmentSlotType;

	public function new(name:String, slotKey:String, slotType:EquipmentSlotType)
	{
		this.name = name;
		this.slotKey = slotKey;
		this.slotType = slotType;
	}
}
