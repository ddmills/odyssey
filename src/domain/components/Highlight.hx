package domain.components;

import data.ColorKey;
import ecs.Component;

class Highlight extends Component
{
	@save public var color:Int = ColorKey.C_YELLOW;
	@save public var showArrow:Bool = false;
	@save public var showRing:Bool = true;
	@save public var animated:Bool = false;

	public function new() {}
}
