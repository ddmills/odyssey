package domain.terrain.gen.pois;

import common.algorithm.BSP;
import common.struct.IntPoint;
import data.Cardinal;
import hxd.Rand;

class PoiLayoutFortress extends PoiLayout
{
	public function apply(poi:ZonePoi, r:Rand):Array<Room>
	{
		var exteriorPad = 2;
		var interiorPad = 2;
		var interiorOffX = exteriorPad + (interiorPad * 2);
		var interiorOffY = exteriorPad + (interiorPad * 2);
		var interiorW = poi.width - (interiorOffX * 2) + 1;
		var interiorH = poi.height - (interiorOffY * 2) + 1;

		var graph = BSP.createGraph(r, {
			width: interiorW,
			height: interiorH,
			minNodeWidth: 6,
			minNodeHeight: 6,
			maxNodeWidth: 12,
			maxNodeHeight: 12,
			splitIgnoreChance: .5,
		});

		var rooms:Array<Room> = [];

		for (node in graph)
		{
			if (!node.isLeaf)
			{
				continue;
			}

			var offX = interiorOffX + node.offsetX;
			var offY = interiorOffY + node.offsetY;

			var room = new Room(offX, offY, node.width - 1, node.height - 1);
			room.includeWalls = false;

			rooms.push(room);

			for (x in 0...node.width)
			{
				if (node.offsetY != 0 && node.offsetX + x < interiorW - 1)
				{
					var p = new IntPoint(offX + x, offY - 1);

					poi.setTile(p, {
						primary: C_GRAY_4,
						tileKey: TERRAIN_BASIC_1,
						background: C_BLUE_4,
						content: [
							{
								spawnableType: WOOD_WALL,
								spawnableSettings: {},
							}
						],
					});
				}
			}

			for (y in 0...node.height)
			{
				if (node.offsetX != 0 && node.offsetY + y < interiorH - 1)
				{
					var p = new IntPoint(offX - 1, offY + y);
					poi.setTile(p, {
						primary: C_GRAY_4,
						tileKey: TERRAIN_BASIC_1,
						background: C_BLUE_4,
						content: [
							{
								spawnableType: WOOD_WALL,
								spawnableSettings: {},
							}
						],
					});
				}
			}
		}

		// spawn doors
		for (node in graph)
		{
			if (node.parentId == -1)
			{
				continue;
			}

			var sibling = graph.find((n) -> n.id == node.siblingId);
			var doorCandidates = new Array<IntPoint>();

			if (sibling.offsetX < node.offsetX)
			{
				for (i in 0...(node.height - 1))
				{
					var x = interiorOffX + node.offsetX - 1;
					var y = interiorOffY + node.offsetY + i;
					var p = new IntPoint(x, y);
					var left = poi.getTile({x: x - 1, y: y});
					var right = poi.getTile({x: x + 1, y: y});

					if (left.isNull() && right.isNull())
					{
						doorCandidates.push({x: x, y: y});
					}
				}
			}
			else if (sibling.offsetY < node.offsetY)
			{
				for (i in 0...(node.width - 1))
				{
					var x = interiorOffX + node.offsetX + i;
					var y = interiorOffY + node.offsetY - 1;
					var p = new IntPoint(x, y);
					var top = poi.getTile({x: x, y: y - 1});
					var bot = poi.getTile({x: x, y: y + 1});

					if (top.isNull() && bot.isNull())
					{
						doorCandidates.push({x: x, y: y});
					}
				}
			}

			if (doorCandidates.length > 0)
			{
				var door = r.pick(doorCandidates);

				poi.setTile(door, {
					primary: C_GRAY_4,
					tileKey: TERRAIN_BASIC_2,
					background: C_PURPLE_3,
					content: [
						{
							spawnableType: WOOD_DOOR,
							spawnableSettings: {},
						}
					],
				});
			}
		}

		for (x in 0...poi.width)
		{
			// exterior top/bottom wall
			if (x >= exteriorPad && x < poi.width - exteriorPad - 1)
			{
				var wallTop = new IntPoint(x, exteriorPad);
				var wallBot = new IntPoint(x, poi.height - exteriorPad - 1);

				poi.setTile(wallTop, {
					primary: C_GRAY_5,
					tileKey: TERRAIN_BASIC_1,
					content: [
						{
							spawnableType: STONE_WALL,
							spawnableSettings: {},
						}
					],
				});
				poi.setTile(wallBot, {
					primary: C_GRAY_5,
					tileKey: TERRAIN_BASIC_1,
					content: [
						{
							spawnableType: STONE_WALL,
							spawnableSettings: {},
						}
					],
				});
			}

			// interior top/bottom wall
			if (x >= interiorOffX && x < interiorOffX + interiorW)
			{
				var interiorWallTop = new IntPoint(x, interiorOffY - 1);
				var interiorWallBot = new IntPoint(x, interiorH + interiorOffY - 1);

				if (!(r.bool(.15) && tryDoor(interiorWallTop, poi, true)))
				{
					poi.setTile(interiorWallTop, {
						primary: C_RED_5,
						background: C_RED_5,
						tileKey: TERRAIN_BASIC_1,
						content: [
							{
								spawnableType: WOOD_WALL,
								spawnableSettings: {},
							}
						],
					});
				}
				if (!(r.bool(.15) && tryDoor(interiorWallBot, poi, true)))
				{
					poi.setTile(interiorWallBot, {
						primary: C_RED_5,
						background: C_RED_5,
						tileKey: TERRAIN_BASIC_1,
						content: [
							{
								spawnableType: WOOD_WALL,
								spawnableSettings: {},
							}
						],
					});
				}
			}

			for (y in 0...interiorPad)
			{
				var t = new IntPoint(x, exteriorPad + y + 1);
				var b = new IntPoint(x, poi.height - exteriorPad - y - 2);

				poi.setTile(t, {
					primary: C_GRAY_5,
					background: C_GRAY_5,
					tileKey: TERRAIN_BASIC_1,
					content: [],
				});
				poi.setTile(b, {
					primary: C_GRAY_5,
					background: C_GRAY_5,
					tileKey: TERRAIN_BASIC_1,
					content: [],
				});
			}

			for (y in 0...exteriorPad)
			{
				var t = new IntPoint(x, y);
				var b = new IntPoint(x, poi.height - y - 1);

				poi.setTile(t, {
					primary: C_GRAY_5,
					tileKey: TERRAIN_BASIC_1,
					content: [],
				});
				poi.setTile(b, {
					primary: C_GRAY_5,
					tileKey: TERRAIN_BASIC_1,
					content: [],
				});
			}
		}

		for (y in exteriorPad...(poi.height - exteriorPad))
		{
			// exterior wall
			if (y >= exteriorPad && y < poi.height - exteriorPad)
			{
				var wallLeft = new IntPoint(exteriorPad, y);
				var wallRight = new IntPoint(poi.width - exteriorPad - 1, y);

				poi.setTile(wallLeft, {
					primary: C_GRAY_5,
					tileKey: TERRAIN_BASIC_1,
					content: [
						{
							spawnableType: STONE_WALL,
							spawnableSettings: {},
						}
					],
				});
				poi.setTile(wallRight, {
					primary: C_GRAY_5,
					tileKey: TERRAIN_BASIC_1,
					content: [
						{
							spawnableType: STONE_WALL,
							spawnableSettings: {},
						}
					],
				});
			}

			// interior wall
			if (y >= (interiorOffY - 1) && y < interiorOffY + interiorH)
			{
				var interiorWallLeft = new IntPoint(interiorOffX - 1, y);
				var interiorWallRight = new IntPoint(interiorW + interiorOffX - 1, y);

				if (!(r.bool(.15) && tryDoor(interiorWallLeft, poi, false)))
				{
					poi.setTile(interiorWallLeft, {
						primary: C_RED_5,
						background: C_RED_5,
						tileKey: TERRAIN_BASIC_1,
						content: [
							{
								spawnableType: WOOD_WALL,
								spawnableSettings: {},
							}
						],
					});
				}

				if (!(r.bool(.15) && tryDoor(interiorWallRight, poi, false)))
				{
					poi.setTile(interiorWallRight, {
						primary: C_RED_5,
						background: C_RED_5,
						tileKey: TERRAIN_BASIC_1,
						content: [
							{
								spawnableType: WOOD_WALL,
								spawnableSettings: {},
							}
						],
					});
				}
			}

			if (y > exteriorPad && y < poi.height - exteriorPad - 1)
			{
				for (x in 0...interiorPad)
				{
					var t = new IntPoint(exteriorPad + x + 1, y);
					var b = new IntPoint(poi.width - exteriorPad - x - 2, y);

					poi.setTile(t, {
						primary: C_GRAY_5,
						background: C_GRAY_5,
						tileKey: TERRAIN_BASIC_1,
						content: [],
					});

					poi.setTile(b, {
						primary: C_GRAY_5,
						background: C_GRAY_5,
						tileKey: TERRAIN_BASIC_1,
						content: [],
					});
				}
			}

			for (x in 0...exteriorPad)
			{
				var t = new IntPoint(x, y);
				var b = new IntPoint(poi.width - x - 1, y);

				poi.setTile(t, {
					primary: C_GRAY_5,
					tileKey: TERRAIN_BASIC_1,
					content: [],
				});
				poi.setTile(b, {
					primary: C_GRAY_5,
					tileKey: TERRAIN_BASIC_1,
					content: [],
				});
			}
		}

		return rooms;
	}

	private function tryDoor(p:IntPoint, poi:ZonePoi, northSouth:Bool):Bool
	{
		var offA:IntPoint = northSouth ? {x: 0, y: 1} : {x: 1, y: 0};
		var offB:IntPoint = northSouth ? {x: 0, y: -1} : {x: -1, y: 0};

		var a = poi.getTile(p.add(offA));
		var b = poi.getTile(p.add(offB));

		if (!a.isNull() || !b.isNull())
		{
			return false;
		}

		poi.setTile(p, {
			primary: C_GRAY_5,
			background: C_GRAY_5,
			tileKey: TERRAIN_BASIC_1,
			content: [
				{
					spawnableType: WOOD_DOOR,
					spawnableSettings: {},
				}
			],
		});

		return true;
	}
}
