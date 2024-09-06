package domain.terrain.gen.pois;

import common.algorithm.BSP;
import common.struct.IntPoint;
import data.TileKey;
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
				var terrains:Array<TileKey> = [TERRAIN_BASIC_2, TERRAIN_BASIC_3, TERRAIN_BASIC_4, TERRAIN_BASIC_5];

				if (node.offsetY > 0)
				{
					for (x in 0...node.width)
					{
						poi.setTile({
							x: node.offsetX + x,
							y: node.offsetY,
						}, {
							content: [],
							tileKey: TERRAIN_BASIC_5,
							primary: C_DARK_RED,
							background: C_WOOD,
						});
						poi.setTile({
							x: node.offsetX + x,
							y: node.offsetY - 1,
						}, {
							content: r.bool(.05) ? [{spawnableType: STREETLAMP}] : [],
							tileKey: r.pick(terrains),
							primary: C_DARK_RED,
							background: C_WOOD,
						});
						poi.setTile({
							x: node.offsetX + x,
							y: node.offsetY + 1,
						}, {
							content: r.bool(.05) ? [{spawnableType: STREETLAMP}] : [],
							tileKey: r.pick(terrains),
							primary: C_DARK_RED,
							background: C_WOOD,
						});
					}
				}

				if (node.offsetX > 0)
				{
					for (y in 0...node.height)
					{
						poi.setTile({
							x: node.offsetX,
							y: node.offsetY + y,
						}, {
							content: [],
							tileKey: TERRAIN_BASIC_5,
							primary: C_DARK_RED,
							background: C_WOOD,
						});
						poi.setTile({
							x: node.offsetX - 1,
							y: node.offsetY + y,
						}, {
							content: r.bool(.05) ? [{spawnableType: STREETLAMP}] : [],
							tileKey: r.pick(terrains),
							primary: C_DARK_RED,
							background: C_WOOD,
						});
						poi.setTile({
							x: node.offsetX + 1,
							y: node.offsetY + y,
						}, {
							content: r.bool(.05) ? [{spawnableType: STREETLAMP}] : [],
							tileKey: r.pick(terrains),
							primary: C_DARK_RED,
							background: C_WOOD,
						});
					}
				}
			}
		}

		return rooms;
	}
}
