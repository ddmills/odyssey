package domain.components;

import ecs.Component;

class EquipmentSlot extends Component
{
	static var allowMultiple = true;

	public var name:String;

	public function new(name:String)
	{
		this.name = name;
	}
}
