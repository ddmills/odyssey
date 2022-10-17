package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class TalkEvent extends EntityEvent
{
	public var talker(default, null):Entity;

	public function new(talker:Entity)
	{
		this.talker = talker;
	}
}
