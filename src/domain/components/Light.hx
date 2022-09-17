package domain.components;

import data.LightChannel;
import ecs.Component;

class Light extends Component
{
	@save public var intensity:Float;
	@save public var height:Int;
	@save public var colour:Int;
	@save public var channel:LightChannel;

	public function new(intensity:Float = 1, colour:Int = 0xffffff, height:Int = 1, channel:LightChannel = ALL_CHANNELS)
	{
		this.intensity = intensity;
		this.height = height;
		this.colour = colour;
		this.channel = channel;
	}
}
