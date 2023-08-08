package domain.components;

import data.ColorKey;
import ecs.Component;

class FloatingText extends Component
{
	public var text:String;
	public var color:ColorKey;
	public var lifetime:Float;
	public var duration:Float;

	public function new(text:String, color:ColorKey, duration:Float)
	{
		this.text = text;
		this.color = color;
		this.duration = duration;
		this.lifetime = 0;
	}
}
