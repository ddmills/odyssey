package domain.components;

import common.struct.Coordinate;
import domain.ai.BehaviourType;
import ecs.Component;

class Actor extends Component
{
	@save public var behaviour:BehaviourType;
	@save public var lastKnownTargetPosition:Null<Coordinate>;
	@save public var loiterPosition:Null<Coordinate>;

	public function new(behaviour:BehaviourType)
	{
		this.behaviour = behaviour;
		this.lastKnownTargetPosition = null;
	}

	override function onAttach()
	{
		this.loiterPosition = entity.pos;
	}
}
