package domain.components;

import ecs.Component;
import ecs.Entity;

class IsInventoried extends Component
{
	@save private var _holderId:String;

	public var holder(get, set):Null<Entity>;

	public function new(holderId:String)
	{
		_holderId = holderId;
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
