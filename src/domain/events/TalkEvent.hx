package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class TalkEvent extends EntityEvent
{
	private var talker:Entity;

	public function new(talker:Entity)
	{
		this.talker = talker;
	}
}
