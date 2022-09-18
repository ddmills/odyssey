package domain.components;

import ecs.Component;

class LightSource extends Component
{
	// must be between 0 and 1
	@save public var intensity:Float;
	@save public var range:Int;
	@save public var colour:Int;

	public function new(intensity:Float = .5, colour:Int = 0xffffff, range:Int = 5)
	{
		this.intensity = intensity;
		this.range = range;
		this.colour = colour;
	}
}
