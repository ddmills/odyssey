package domain.components;

import ecs.Component;

class Vision extends Component
{
	@save public var range:Int;

	/**
	 * Bonus vision is grants extra range, but only marks tiles as "Explored" rather than visible
	 */
	@save public var bonus:Int;

	public function new(range:Int = 6, bonus:Int = 0)
	{
		this.range = range;
		this.bonus = bonus;
	}
}
