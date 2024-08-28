package domain.components;

import domain.ai.BehaviourType;
import ecs.Component;

class Actor extends Component
{
	@save public var behaviour:BehaviourType;

	public function new(behaviour:BehaviourType)
	{
		this.behaviour = behaviour;
	}
}
