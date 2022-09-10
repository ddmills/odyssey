package domain.components;

import ecs.Component;

class Energy extends Component
{
	@save public var value(default, null):Int = 5;

	public var hasEnergy(get, never):Bool;

	public function new() {}

	public function addEnergy(value:Int)
	{
		this.value += value;

		if (this.value > 0)
		{
			this.value = 0;
		}
	}

	public function consumeEnergy(value:Int)
	{
		addEnergy(-1 * value);
	}

	inline function get_hasEnergy():Bool
	{
		return value >= 0;
	}
}
