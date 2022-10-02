package domain.terrain.gen.pois;

import hxd.Rand;

class PoiLayoutScattered extends PoiLayout
{
	public function apply(poi:ZonePoi, r:Rand):Array<Room>
	{
		return [new Room(1, 1, 24, 16), new Room(30, 24, 8, 12), new Room(1, 30, 8, 6),];
	}
}
