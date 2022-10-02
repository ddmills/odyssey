package domain.terrain.gen.rooms;

import common.struct.WeightedTable;
import data.ColorKey;
import data.SpawnableType;
import hxd.Rand;

class RoomSheriffOffice extends RoomDecorator
{
	private var clutter:WeightedTable<SpawnableType>;

	public function new()
	{
		super();
		clutter = new WeightedTable();
		clutter.add(TABLE, 100);
		clutter.add(CHAIR, 100);
		clutter.add(CABINET, 100);
	}

	public function decorate(r:Rand, room:Room, zone:ZonePoi):Void
	{
		room.tiles.fillFn((idx) ->
		{
			var pos = room.tiles.coord(idx);
			var tile = new RoomTile([]);
			var midY = (room.height / 2).round();

			if (room.isOnEdge(pos))
			{
				tile.tileKey = FLOORBOARDS;
				tile.primary = C_BLACK_1;
				tile.background = C_RED_3;

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
			}
			else
			{
				tile.tileKey = FLOORBOARDS;
				tile.primary = C_BLACK_1;
				tile.background = C_RED_3;

				if (pos.y <= 2) // prison cell
				{
					if (pos.y == 2)
					{
						tile.content.push({
							spawnableType: FENCE_BARS,
							spawnableSettings: {},
						});
					}
				}
				else
				{
					if (r.bool(.05))
					{
						tile.content.push({
							spawnableType: clutter.pick(r),
							spawnableSettings: {},
						});
					}
				}
			}

			return tile;
		});
	}
}
