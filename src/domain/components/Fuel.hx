package domain.components;

import data.FuelType;
import ecs.Component;

class Fuel extends Component
{
	@save public var fuelType:FuelType;
	@save public var amountPerStack:Int;

	public var amount(get, set):Int;

	public function new(fuelType:FuelType, amountPerStack:Int = 1)
	{
		this.fuelType = fuelType;
		this.amountPerStack = amountPerStack;
	}

	function get_amount():Int
	{
		var stack = entity.get(Stackable);
		if (stack != null)
		{
			return stack.quantity * amountPerStack;
		}

		return amountPerStack;
	}

	function set_amount(value:Int):Int
	{
		if (amount <= 0)
		{
			entity.add(new IsDestroyed());
			return 0;
		}

		var stack = entity.get(Stackable);
		if (stack != null)
		{
			stack.quantity = (value / amountPerStack).floor();

			if (stack.quantity <= 0)
			{
				entity.add(new IsDestroyed());
			}
		}

		return value;
	}
}
