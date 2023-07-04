package domain.components;

import data.ColorKey;
import ecs.Component;
import h2d.Bitmap;

class Highlight extends Component
{
	@save public var color:Int = ColorKey.C_YELLOW_2;

	public function new() {}
}
