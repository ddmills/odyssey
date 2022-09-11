package domain.components;

import ecs.Component;

class HitBlink extends Component
{
	// static var allowMultiple = true;
	@save public var time:Float = 0;

	public function new() {}
}
