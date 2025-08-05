package domain.terrain.gen.pois;

import core.Game;
import hxd.Rand;

class PoiLayoutBasicSquare extends PoiLayout
{
	public function apply(poi:ZonePoi, r:Rand):Array<Room>
	{
		var zone = Game.instance.world.map.zones.getZoneById(poi.zoneId);
		var roomWidth = 14;
		var roomHeight = 14;
		var middleX = (zone.size / 2).floor();
		var middleY = (zone.size / 2).floor();

		var tlX = (middleX - (roomWidth / 2)).floor();
		var tlY = (middleY - (roomHeight / 2)).floor();

		var r = new Room(tlX, tlY, roomWidth, roomHeight);

		return [r];
	}
}
