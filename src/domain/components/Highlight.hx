package domain.components;

import data.ColorKey;
import ecs.Component;

class Highlight extends Component
{
	@save public var color:Int = ColorKey.C_YELLOW_2;
	@save public var showArrow:Bool = false;

	public function new() {}
}
