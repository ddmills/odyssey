package domain.terrain.gen.rooms;

import common.struct.FloatPoint;
import common.struct.IntPoint;
import data.ColorKey;
import data.TileKey;
import hxd.Rand;

class RoomCamp extends RoomDecorator
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

		var middle = new IntPoint((room.width / 2).floor(), (room.height / 2).floor());

		// dirt patch around fire
		for (dx in -1...2)
		{
			for (dy in -1...2)
			{
				room.tiles.set(middle.x + dx, middle.y + dy, {
					tileKey: TileKey.TERRAIN_BASIC_4,
					primary: ColorKey.C_BROWN,
					content: []
				});
			}
		}

		// campfire at center
		room.tiles.set(middle.x, middle.y, {
			tileKey: TileKey.TERRAIN_BASIC_1,
			primary: ColorKey.C_BROWN,
			content: [
				{
					spawnableType: CAMPFIRE,
				}
			]
		});

		// chest to north
		room.tiles.set(middle.x, middle.y - 3, {
			content: [
				{
					spawnableType: CHEST,
				}
			]
		});

		// Barrels
		room.tiles.set(middle.x - 1, middle.y - 3, {
			content: [
				{
					spawnableType: BARREL,
				}
			]
		});
		room.tiles.set(middle.x - 1, middle.y - 4, {
			content: [
				{
					spawnableType: BARREL,
				}
			]
		});

		// chairs
		room.tiles.set(middle.x - 3, middle.y, {
			content: [
				{
					spawnableType: CHAIR,
				}
			]
		});
		room.tiles.set(middle.x + 3, middle.y, {
			content: [
				{
					spawnableType: CHAIR,
				}
			]
		});

		// lantern
		room.tiles.set(middle.x + 3, middle.y + 3, {
			content: [
				{
					spawnableType: LANTERN,
					spawnableSettings: {
						isLit: true
					}
				}
			]
		});

		// bandits
		room.tiles.set(middle.x + 3, middle.y - 3, {
			content: [
				{
					spawnableType: THUG,
				}
			]
		});
		room.tiles.set(middle.x - 3, middle.y - 3, {
			content: [
				{
					spawnableType: THUG,
				}
			]
		});

		room.tiles.set(middle.x - 3, middle.y + 3, {
			content: [
				{
					spawnableType: THUG,
				}
			]
		});
	}
}
