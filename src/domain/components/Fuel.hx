package domain.components;

import data.FuelType;
import ecs.Component;

class Fuel extends Component
{
	@save public var fuelType:FuelType;
	@save public var amountPerStack:Int;
	@save public var allowPartial:Bool;

	public var amount(get, never):Int;

	public function new(fuelType:FuelType, amountPerStack:Int = 1, allowPartial:Bool = true)
	{
		this.fuelType = fuelType;
		this.amountPerStack = amountPerStack;
		this.allowPartial = allowPartial;
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

	public function consume(value:Int)
	{
		var stack = entity.get(Stackable);

		if (stack != null)
		{
			stack.quantity -= (value / amountPerStack).floor();

			if (stack.quantity <= 0)
			{
				entity.add(new IsDestroyed());
			}
		}
		else
		{
			entity.add(new IsDestroyed());
		}
	}
}
