package domain.terrain.gen.pois;

import common.algorithm.BSP;
import hxd.Rand;

class PoiLayoutScattered extends PoiLayout
{
	public function apply(poi:ZonePoi, r:Rand):Array<Room>
	{
		var graph = BSP.createGraph(r, {
			width: poi.width,
			height: poi.height,
			minNodeWidth: 8,
			minNodeHeight: 8,
			maxNodeWidth: 16,
			maxNodeHeight: 16,
			splitIgnoreChance: .8,
		});

		var rooms:Array<Room> = [];
		for (node in graph)
		{
			if (node.isLeaf)
			{
				rooms.push(new Room(node.offsetX + 1, node.offsetY + 1, node.width - 2, node.height - 2));
			}
		}

		return rooms;
	}
}
