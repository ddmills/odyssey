package domain.terrain.gen.rooms;

import data.SpawnableType;
import hxd.Rand;

class RoomGrove extends RoomDecorator
{
	private var treeType:SpawnableType;

	public function new(treeType:SpawnableType)
	{
		super();
		this.treeType = treeType;
	}

	public function decorate(r:Rand, room:Room, zone:ZonePoi):Void
	{
		room.tiles.fillFn((idx) ->
		{
			var pos = room.tiles.coord(idx);
			var tile:RoomTile = {
				content: [],
			};

			tile.tileKey = TERRAIN_BASIC_5;

			if (room.isOnEdge(pos))
			{
				var midX = (room.width / 2).floor();

				if (pos.x < (midX - 1) || pos.x > (midX + 1))
				{
					tile.content.push({
						spawnableType: FENCE_BARBED,
						spawnableSettings: {},
					});
				}
			}
			else
			{
				if (r.bool(.5))
				{
					tile.content.push({
						spawnableType: this.treeType,
						spawnableSettings: {},
					});
				}
			}

			return tile;
		});
	}
}
