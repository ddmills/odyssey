package domain.terrain.gen;

import domain.terrain.gen.pois.PoiLayouts;
import domain.terrain.gen.rooms.RoomDecorators;
import hxd.Rand;

class PoiGenerator
{
	public static function Generate(poi:ZonePoi)
	{
		var layout = PoiLayouts.Get(poi.template.layout);
		var r = new Rand(poi.zoneId);

		var options = layout.apply(poi, r);

		for (roomTemplate in poi.template.rooms)
		{
			var decorator = RoomDecorators.Get(roomTemplate.type);
			var room = r.pick(options);
			decorator.decorate(r, room, poi);
			poi.rooms.push(room);
		}
	}
}
