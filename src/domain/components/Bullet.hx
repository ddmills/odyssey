package domain.components;

import data.AudioKey;
import ecs.Component;

class Bullet extends Component
{
	@save public var impactSound:AudioKey;

	public function new() {}
}
