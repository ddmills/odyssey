package domain.components;

import data.ColorKey;
import ecs.Component;

class FloatingText extends Component
{
	public var text:String;
	public var color:ColorKey;
	public var lifetime:Float;
	public var speed:Float;

	public function new(text:String, color:ColorKey, lifetime:Float, speed:Float)
	{
		this.text = text;
		this.color = color;
		this.lifetime = lifetime;
		this.speed = speed;
	}
}
