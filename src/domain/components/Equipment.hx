package domain.components;

import data.EquipmentSlotType;
import ecs.Component;

class Equipment extends Component
{
	public var slotTypes:Array<EquipmentSlotType>;

	public function new(slotTypes:Array<EquipmentSlotType>)
	{
		this.slotTypes = slotTypes;
	}
}
