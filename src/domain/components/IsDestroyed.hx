package domain.components;

import ecs.Component;

class IsDestroyed extends Component
{
	@save public var pass:Int = 0;

	public function new() {}
}
