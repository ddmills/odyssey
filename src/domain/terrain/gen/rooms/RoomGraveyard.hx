package domain.terrain.gen.rooms;

import common.struct.WeightedTable;
import data.SpawnableType;
import hxd.Rand;

class RoomGraveyard extends RoomDecorator
{
	private var clutter:WeightedTable<SpawnableType>;

	public function new()
	{
		super();
		clutter = new WeightedTable();
		clutter.add(CORPSE_HUMAN, 100);
		clutter.add(CORPSE_SNAKE, 100);
		clutter.add(LANTERN, 20);
	}

	public function decorate(r:Rand, room:Room, zone:ZonePoi):Void
	{
		room.tiles.fillFn((idx) ->
		{
			var pos = room.tiles.coord(idx);
			var tile:RoomTile = {
				content: [],
			};

			tile.tileKey = TERRAIN_BASIC_1;

			if (room.isOnEdge(pos))
			{
				var midX = (room.width / 2).floor();

				if (pos.x < (midX - 1) || pos.x > (midX + 1))
				{
					tile.content.push({
						spawnableType: FENCE_IRON,
						spawnableSettings: {},
					});
				}
			}
			else if (pos.x.isEven() && pos.y % 3 == 0 && r.bool(.75))
			{
				tile.content.push({
					spawnableType: TOMBSTONE,
					spawnableSettings: {},
				});
			}
			else if (r.bool(.05))
			{
				tile.content.push({
					spawnableType: clutter.pick(r),
					spawnableSettings: {},
				});
			}

			return tile;
		});
	}
}
