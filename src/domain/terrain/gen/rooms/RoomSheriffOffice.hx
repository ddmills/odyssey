package domain.terrain.gen.rooms;

import common.struct.WeightedTable;
import data.ColorKeys;
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
			var midY = (room.width / 2).floor();

			if (room.isOnEdge(pos))
			{
				tile.tileKey = TERRAIN_BASIC_1;
				tile.primary = ColorKeys.C_GRAY_2;
				tile.background = ColorKeys.C_BLACK_1;

				if (pos.y < midY || pos.y > midY)
				{
					tile.content.push({
						spawnableType: WOOD_WALL,
						spawnableSettings: {},
					});
				}
			}
			else
			{
				tile.tileKey = FLOORBOARDS;
				tile.primary = ColorKeys.C_BLACK_1;
				tile.background = ColorKeys.C_RED_3;

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
