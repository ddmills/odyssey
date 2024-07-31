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

			if (!room.isOnEdge(pos))
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
