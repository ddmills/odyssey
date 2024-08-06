package domain.terrain.gen.rooms;

import common.struct.WeightedTable;
import hxd.Rand;

class RoomSheriffOffice extends RoomDecorator
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
		}, 200);
		clutter.add({
			spawnableType: TABLE,
			spawnableSettings: {}
		}, 100);
		clutter.add({
			spawnableType: CHAIR,
			spawnableSettings: {}
		}, 100);
		clutter.add({
			spawnableType: CABINET,
			spawnableSettings: {}
		}, 100);
		clutter.add({
			spawnableType: TALL_CABINET,
			spawnableSettings: {}
		}, 100);
		clutter.add({
			spawnableType: CHEST,
			spawnableSettings: {}
		}, 100);
		clutter.add({
			spawnableType: VILLAGER,
			spawnableSettings: {}
		}, 200);
	}

	public function decorate(r:Rand, room:Room, zone:ZonePoi):Void
	{
		room.tiles.fillFn((idx) ->
		{
			var pos = room.tiles.coord(idx);

			var tile:RoomTile = {
				content: [],
			};
			var midY = (room.height / 2).round();
			var midX = (room.width / 2).round();

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
							spawnableType: WOOD_WALL_WINDOW,
							spawnableSettings: {},
						});
					}
					else if (pos.y > 2 && pos.x > 0 && pos.x < room.width - 1 && r.bool(.25))
					{
						tile.content.push({
							spawnableType: WOOD_WALL_WINDOW,
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
				else
				{
					tile.content.push({
						spawnableType: WOOD_DOOR,
						spawnableSettings: {
							isOpen: r.bool(.25),
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

				if (pos.y <= 2) // prison cell
				{
					if (pos.y == 2)
					{
						if (pos.x == midX)
						{
							tile.content.push({
								spawnableType: BARS_DOOR,
								spawnableSettings: {},
							});
						}
						else
						{
							tile.content.push({
								spawnableType: FENCE_BARS,
								spawnableSettings: {},
							});
						}
					}
					else
					{
						if (r.bool(.15))
						{
							tile.content.push({
								spawnableType: BEDROLL,
								spawnableSettings: {},
							});
						}
					}
				}
				else
				{
					if (r.bool(.05))
					{
						tile.content.push(clutter.pick(r));
					}
				}
			}

			return tile;
		});
	}
}
