package domain.components;

import data.StackableType;
import ecs.Component;

class Stackable extends Component
{
	@save public var stackType:StackableType;
	@save public var quantity:Int = 1;

	public var displayName(get, never):String;

	public function new(stackType:StackableType, quantity:Int = 1)
	{
		this.stackType = stackType;
		this.quantity = quantity;
	}

	public function addOther(other:Stackable)
	{
		quantity += other.quantity;
		other.quantity = 0;
		other.entity.add(new IsDestroyed());
	}

	function get_displayName():String
	{
		if (quantity > 1)
		{
			return 'x $quantity';
		}
		return '';
	}
}
