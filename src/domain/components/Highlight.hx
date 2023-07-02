package domain.components;

import data.ColorKey;
import ecs.Component;
import h2d.Bitmap;

class Highlight extends Component
{
	@save public var color:Int = ColorKey.C_RED_1;

	public function new() {}
}
