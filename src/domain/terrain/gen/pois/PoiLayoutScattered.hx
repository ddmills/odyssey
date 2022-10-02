package domain.terrain.gen.pois;

import common.algorithm.BSP;
import common.struct.IntPoint;
import hxd.Rand;

class PoiLayoutScattered extends PoiLayout
{
	public function apply(poi:ZonePoi, r:Rand):Array<Room>
	{
		var graph = BSP.createGraph(r, {
			width: poi.width,
			height: poi.height,
			minNodeWidth: 10,
			minNodeHeight: 10,
			maxNodeWidth: 16,
			maxNodeHeight: 16,
			splitIgnoreChance: .5,
		});

		var rooms:Array<Room> = [];
		for (node in graph)
		{
			if (node.isLeaf)
			{
				var wpad = r.integer(2, 6);
				var hpad = r.integer(2, 6);
				var width = node.width - wpad;
				var height = node.height - hpad;

				var offX = node.offsetX + r.integer(1, wpad);
				var offY = node.offsetY + r.integer(1, hpad);

				rooms.push(new Room(offX, offY, width, height));

				if (node.offsetY > 0)
				{
					for (x in 0...node.width)
					{
						var pos:IntPoint = {
							x: node.offsetX + x,
							y: node.offsetY,
						};

						var tile = new RoomTile([]);
						tile.tileKey = TERRAIN_BASIC_5;
						tile.primary = C_BLACK_1;
						tile.background = C_RED_3;

						poi.setTile(pos, tile);
					}
				}

				if (node.offsetX > 0)
				{
					for (y in 0...node.height)
					{
						var pos:IntPoint = {
							x: node.offsetX,
							y: node.offsetY + y,
						};

						var tile = new RoomTile([]);
						tile.tileKey = TERRAIN_BASIC_5;
						tile.primary = C_BLACK_1;
						tile.background = C_RED_3;

						poi.setTile(pos, tile);
					}
				}
			}
		}

		return rooms;
	}
}
