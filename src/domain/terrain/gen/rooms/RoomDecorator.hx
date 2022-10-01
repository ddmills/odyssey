package domain.terrain.gen.rooms;

import hxd.Rand;

abstract class RoomDecorator
{
	public function new() {}

	public abstract function decorate(r:Rand, room:Room, poi:ZonePoi):Void;
}
