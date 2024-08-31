package domain.components;

import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Game;
import domain.ai.BehaviourType;
import domain.events.EntitySpawnedEvent;
import ecs.Component;
import ecs.Entity;

class Actor extends Component
{
	@save public var behaviour:BehaviourType;
	@save public var lastKnownTargetPosition:Null<Coordinate>;
	@save public var leaderEntityId:Null<String>;
	@save public var loiterPosition:Null<Coordinate>;
	@save public var path:Null<Array<IntPoint>>;

	public var leader(get, never):Null<Entity>;

	public function new(behaviour:BehaviourType)
	{
		this.behaviour = behaviour;
		this.lastKnownTargetPosition = null;
		this.path = null;

		addHandler(EntitySpawnedEvent, onEntitySpawned);
	}

	private function onEntitySpawned(evt:EntitySpawnedEvent)
	{
		this.loiterPosition = entity.pos;
	}

	inline function get_leader():Null<Dynamic>
	{
		return Game.instance.registry.getEntity(leaderEntityId);
	}
}
