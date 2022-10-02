package domain.terrain.gen.pois;

import hxd.Rand;

abstract class PoiLayout
{
	public function new() {}

	public abstract function apply(poi:ZonePoi, r:Rand):Array<Room>;
}
