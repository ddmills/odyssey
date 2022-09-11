package domain.events;

import ecs.EntityEvent;

class LevelUpEvent extends EntityEvent
{
	public var level:Int;

	public function new(level:Int)
	{
		this.level = level;
	}
}
