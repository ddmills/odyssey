package domain.components;

import common.util.Easing.EasingType;
import data.Cardinal;
import ecs.Component;

class BumpAttack extends Component
{
	@save public var direction:Cardinal;
	@save public var duration:Float;
	@save public var ease:EasingType;

	public var startTime:Float;

	public function new(direction:Cardinal, duration:Float = .1, ease:EasingType = EASE_LINEAR)
	{
		this.direction = direction;
		this.duration = duration;
		this.ease = ease;
	}
}
