package domain.components;

import ecs.Component;

class Vision extends Component
{
	@save public var dayRange:Int;
	@save public var nightRange:Int;

	public function new(dayRange:Int = 6, nightRange:Int = 3)
	{
		this.dayRange = dayRange;
		this.nightRange = nightRange;
	}
}
