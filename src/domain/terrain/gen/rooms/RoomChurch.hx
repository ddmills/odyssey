package domain.terrain.gen.rooms;

import common.struct.WeightedTable;
import hxd.Rand;

class RoomChurch extends RoomDecorator
{
	private var clutter:WeightedTable<RoomContent>;

	public function new()
	{
		super();
		clutter = new WeightedTable();
		clutter.add({
			spawnableType: LANTERN,
			spawnableSettings: {
				isLit: true,
			}
		}, 180);
		clutter.add({
			spawnableType: TABLE,
		}, 50);
		clutter.add({
			spawnableType: CHAIR,
		}, 100);
		clutter.add({
			spawnableType: BRAZIER,
		}, 180);
		clutter.add({
			spawnableType: LOCKBOX,
		}, 100);
		clutter.add({
			spawnableType: BOOKSHELF,
		}, 200);
		clutter.add({
			spawnableType: VILLAGER,
		}, 120);
	}

	public function decorate(r:Rand, room:Room, zone:ZonePoi):Void
	{
		var midY = (room.height / 2).round();
		var midX = (room.width / 2).round();

		room.tiles.fillFn((idx) ->
		{
			var pos = room.tiles.coord(idx);

			var tile:RoomTile = {
				content: [],
			};

			var isMiddle = pos.x == midX && pos.y == midY;

			if (room.includeWalls && room.isOnEdge(pos))
			{
				tile.tileKey = FLOORBOARDS;
				tile.primary = C_DARK_GRAY;
				tile.secondary = C_WOOD;
				tile.background = C_DARK_RED;

				if (pos.y < midY || pos.y > midY)
				{
					if (pos.y > midY + 1 && pos.y < room.height - 1 && r.bool(.25))
					{
						tile.content.push({
							spawnableType: STONE_WALL_WINDOW,
							spawnableSettings: {},
						});
					}
					else if (pos.y > 2 && pos.x > 0 && pos.x < room.width - 1 && r.bool(.25))
					{
						tile.content.push({
							spawnableType: STONE_WALL_WINDOW,
							spawnableSettings: {},
						});
					}
					else
					{
						tile.content.push({
							spawnableType: STONE_WALL,
							spawnableSettings: {},
						});
					}
				}
				else
				{
					tile.content.push({
						spawnableType: WOOD_DOOR,
						spawnableSettings: {
							isOpen: r.bool(.15),
						},
					});
				}
			}
			else
			{
				tile.tileKey = FLOORBOARDS;
				tile.primary = C_DARK_GRAY;
				tile.secondary = C_WOOD;
				tile.background = C_DARK_RED;

				if (isMiddle)
				{
					tile.content.push({
						spawnableType: VILLAGER_PREACHER,
						spawnableSettings: {},
					});
				}
				else if (r.bool(.15))
				{
					tile.content.push(clutter.pick(r));
				}
			}

			return tile;
		});
	}
}
