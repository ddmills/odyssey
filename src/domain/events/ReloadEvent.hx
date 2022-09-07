package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

class ReloadEvent extends EntityEvent
{
	public var reloader:Entity;
	public var isHandled:Bool = false;

	public function new(reloader:Entity)
	{
		this.reloader = reloader;
	}
}
