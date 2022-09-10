package domain.components;

import domain.events.MovedEvent;
import ecs.Component;
import ecs.Entity;

class IsInventoried extends Component
{
	@save private var _holderId:String;

	public var holder(get, set):Null<Entity>;

	public function new(holderId:String)
	{
		_holderId = holderId;
		addHandler(MovedEvent, (evt) -> onMoved(cast evt));
	}

	function onMoved(evt:MovedEvent)
	{
		if (evt.mover.id != entity.id)
		{
			entity.pos = evt.pos;
		}
	}

	function get_holder():Null<Entity>
	{
		return entity.registry.getEntity(_holderId);
	}

	function set_holder(value:Entity):Entity
	{
		_holderId = value.id;

		return value;
	}
}
