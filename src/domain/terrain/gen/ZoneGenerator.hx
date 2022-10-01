package domain.terrain.gen;

import domain.terrain.gen.rooms.RoomGraveyard;
import hxd.Rand;

class ZoneGenerator
{
	public static function Generate(poi:ZonePoi)
	{
		var r = new Rand(poi.zoneId);
		var graveyardGen = new RoomGraveyard();
		var room = new Room(10, 10, 24, 16);

		graveyardGen.decorate(r, room, poi);

		poi.rooms.push(room);

		poi.isGenerated = true;

		return poi;
	}
}
