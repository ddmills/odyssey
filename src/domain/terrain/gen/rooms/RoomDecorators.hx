package domain.terrain.gen.rooms;

import common.struct.DataRegistry;
import data.RoomType;

class RoomDecorators
{
	private static var decorators:DataRegistry<RoomType, RoomDecorator>;

	public static function Init()
	{
		decorators = new DataRegistry();

		decorators.register(ROOM_GRAVEYARD, new RoomGraveyard());
		decorators.register(ROOM_GROVE_OAK, new RoomGrove(OAK_TREE));
		decorators.register(ROOM_GROVE_PINE, new RoomGrove(PINE_TREE));
		decorators.register(ROOM_CHURCH, new RoomChurch());
		decorators.register(ROOM_BLANK, new RoomBlank());
		decorators.register(ROOM_SHERIFF_OFFICE, new RoomSheriffOffice());
		decorators.register(ROOM_RAILROAD_STATION, new RoomRailroadStation());
	}

	public static function Get(type:RoomType):RoomDecorator
	{
		return decorators.get(type);
	}
}
