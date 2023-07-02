package domain.components;

import ecs.Component;

class HitBlink extends Component
{
	@save public var time:Float = 0;

	public function new() {}
}
