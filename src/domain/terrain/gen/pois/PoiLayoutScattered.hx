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
				var wpad = 3;
				var hpad = 3;
				var width = node.width - wpad;
				var height = node.height - hpad;

				var offX = node.offsetX + 2;
				var offY = node.offsetY + 2;

				rooms.push(new Room(offX, offY, width, height));

				if (node.offsetY > 0)
				{
					for (x in 0...node.width)
					{
						var pos:IntPoint = {
							x: node.offsetX + x,
							y: node.offsetY,
						};

						var tile:RoomTile = {
							content: [],
							tileKey: TERRAIN_BASIC_5,
							primary: C_RED_5,
							background: C_RED_3,
						};

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

						var tile:RoomTile = {
							content: [],
							tileKey: TERRAIN_BASIC_5,
							primary: C_RED_5,
							background: C_RED_3,
						};

						poi.setTile(pos, tile);
					}
				}
			}
		}

		return rooms;
	}
}
