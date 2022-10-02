package domain.terrain.gen;

import data.RoomType;
import domain.terrain.gen.pois.PoiLayouts;
import domain.terrain.gen.rooms.RoomDecorator;
import domain.terrain.gen.rooms.RoomDecorators;
import hxd.Rand;

class PoiGenerator
{
	public static function Generate(poi:ZonePoi)
	{
		var layout = PoiLayouts.Get(poi.template.layout);
		var r = new Rand(poi.zoneId);

		var options = layout.apply(poi, r);

		r.shuffle(options);

		for (roomTemplate in poi.template.rooms)
		{
			var decorator = RoomDecorators.Get(roomTemplate.type);
			var room = options.pop();
			decorator.decorate(r, room, poi);
			poi.rooms.push(room);
		}

		for (room in options)
		{
			var type:RoomType = r.pick([ROOM_SHERIFF_OFFICE]);
			var decorator = RoomDecorators.Get(type);
			decorator.decorate(r, room, poi);
			poi.rooms.push(room);
		}
	}
}
