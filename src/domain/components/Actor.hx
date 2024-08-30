package domain.components;

import common.struct.Coordinate;
import common.struct.IntPoint;
import domain.ai.BehaviourType;
import ecs.Component;

class Actor extends Component
{
	@save public var behaviour:BehaviourType;
	@save public var lastKnownTargetPosition:Null<Coordinate>;
	@save public var loiterPosition:Null<Coordinate>;
	@save public var path:Null<Array<IntPoint>>;

	public function new(behaviour:BehaviourType)
	{
		this.behaviour = behaviour;
		this.lastKnownTargetPosition = null;
		this.path = null;
	}

	override function onAttach()
	{
		this.loiterPosition = entity.pos;
	}
}
