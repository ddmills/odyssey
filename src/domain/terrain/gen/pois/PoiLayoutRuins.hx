package domain.terrain.gen.pois;

import common.algorithm.BSP;
import common.rand.Perlin;
import common.struct.IntPoint;
import hxd.Rand;

class PoiLayoutRuins extends PoiLayout
{
	private function hasWall(point:IntPoint, r:Rand, p:Perlin):Bool
	{
		var value = p.get(point, 8, 3);

		return r.bool(value);
	}

	public function apply(poi:ZonePoi, r:Rand):Array<Room>
	{
		var width = r.integer(10, 32);
		var height = r.integer(10, 32);

		var offsetX = ((poi.width - width) / 2).floor();
		var offsetY = ((poi.height - height) / 2).floor();

		var graph = BSP.createGraph(r, {
			width: width,
			height: height,
			minNodeWidth: 4,
			minNodeHeight: 4,
			maxNodeWidth: 8,
			maxNodeHeight: 8,
			splitIgnoreChance: .5,
		});

		var rooms:Array<Room> = [];
		var wallRand = new Perlin(r.getSeed() + poi.zoneId);

		for (x in 0...width)
		{
			var p = new IntPoint(offsetX + x, offsetY + height);

			if (!hasWall(p, r, wallRand))
			{
				continue;
			}

			poi.setTile(p, {
				primary: C_PURPLE,
				tileKey: TERRAIN_BASIC_1,
				content: [
					{
						spawnableType: STONE_WALL,
					}
				],
			});
		}

		for (y in 0...height)
		{
			var p = new IntPoint(offsetX + width, offsetY + y);

			if (!hasWall(p, r, wallRand))
			{
				continue;
			}

			poi.setTile(p, {
				primary: C_PURPLE,
				tileKey: TERRAIN_BASIC_1,
				content: [
					{
						spawnableType: STONE_WALL,
					}
				],
			});
		}

		for (node in graph)
		{
			if (!node.isLeaf)
			{
				continue;
			}

			var offX = offsetX + node.offsetX;
			var offY = offsetY + node.offsetY;

			var room = new Room(offX + 1, offY + 1, node.width - 1, node.height - 1);
			room.includeWalls = false;
			rooms.push(room);

			for (x in 0...node.width)
			{
				var p = new IntPoint(offX + x, offY);

				if (!hasWall(p, r, wallRand))
				{
					continue;
				}

				poi.setTile(p, {
					primary: C_PURPLE,
					tileKey: TERRAIN_BASIC_1,
					content: [
						{
							spawnableType: STONE_WALL,
						}
					],
				});
			}

			for (y in 0...node.height)
			{
				var p = new IntPoint(offX, offY + y);

				if (!hasWall(p, r, wallRand))
				{
					continue;
				}

				poi.setTile(p, {
					primary: C_PURPLE,
					tileKey: TERRAIN_BASIC_1,
					content: [
						{
							spawnableType: STONE_WALL,
						}
					],
				});
			}
		}

		return [];
	}
}
