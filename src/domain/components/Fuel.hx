package domain.components;

import data.FuelType;
import ecs.Component;

class Fuel extends Component
{
	@save public var fuelType:FuelType;
	@save public var amount:Int;

	public function new(fuelType:FuelType, amount:Int = 1)
	{
		this.fuelType = fuelType;
		this.amount = amount;
	}
}
