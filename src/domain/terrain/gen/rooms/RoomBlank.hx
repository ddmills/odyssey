package domain.terrain.gen.rooms;

import hxd.Rand;

class RoomBlank extends RoomDecorator
{
	public function new()
	{
		super();
	}

	public function decorate(r:Rand, room:Room, zone:ZonePoi):Void
	{
		room.tiles.fillFn((idx) ->
		{
			var tile:RoomTile = {
				content: [],
			};

			return tile;
		});
	}
}
