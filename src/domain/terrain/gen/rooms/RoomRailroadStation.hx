package domain.terrain.gen.rooms;

import hxd.Rand;

class RoomRailroadStation extends RoomDecorator
{
	public function decorate(r:Rand, room:Room, poi:ZonePoi):Void
	{
		room.tiles.fillFn((idx) ->
		{
			var pos = room.tiles.coord(idx);
			var tile = new RoomTile([]);
			var midY = (room.height / 2).round();
			var midX = (room.width / 2).round();

			tile.tileKey = FLOORBOARDS;
			tile.primary = C_BLACK_1;
			tile.background = C_RED_3;

			if (room.isOnEdge(pos))
			{
				if (pos.x == midX)
				{
					tile.content.push({
						spawnableType: WOOD_DOOR,
						spawnableSettings: {},
					});
				}
				else
				{
					tile.content.push({
						spawnableType: WOOD_WALL,
						spawnableSettings: {},
					});
				}
			}

			return tile;
		});

		return;
	}
}