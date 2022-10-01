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
	}

	public static function Get(type:RoomType):RoomDecorator
	{
		return decorators.get(type);
	}
}
