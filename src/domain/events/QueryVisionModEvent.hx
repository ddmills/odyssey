package domain.events;

import ecs.EntityEvent;

typedef VisionMod =
{
	source:String,
	minVision:Int,
};

class QueryVisionModEvent extends EntityEvent
{
	public var mods:Array<VisionMod> = [];

	public function new() {}
}
