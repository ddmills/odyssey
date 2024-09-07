package domain.terrain.gen.rooms;

import hxd.Rand;

class RoomRailroadStation extends RoomDecorator
{
	public function decorate(r:Rand, room:Room, poi:ZonePoi):Void
	{
		room.tiles.fillFn((idx) ->
		{
			var pos = room.tiles.coord(idx);
			var tile:RoomTile = {
				content: [],
			};
			var midY = (room.height / 2).round();
			var midX = (room.width / 2).round();

			tile.tileKey = FLOORBOARDS;
			tile.primary = C_DARK_GRAY;
			tile.secondary = C_WOOD;
			tile.background = C_DARK_RED;

			if (room.includeWalls && room.isOnEdge(pos))
			{
				if (pos.x == midX)
				{
					tile.content.push({
						spawnableType: WOOD_DOOR,
						spawnableSettings: {},
					});
				}
				else if (pos.y == midY)
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

		spawnPortals(room, r);

		return;
	}
}
