package domain.terrain.gen.pois;

import core.Game;
import hxd.Rand;

class PoiLayoutRailroadStation extends PoiLayout
{
	public function apply(poi:ZonePoi, r:Rand):Array<Room>
	{
		var zone = Game.instance.world.zones.getZoneById(poi.zoneId);
		var roomWidth = 14;
		var roomHeight = 8;
		var middleX = (zone.size / 2).floor();
		var middleY = (zone.size / 2).floor();

		var tlX = middleX - roomWidth - 1;
		var tlY = middleY - roomHeight - 1;

		for (x in (tlX - 1)...(tlX + roomWidth + 1))
		{
			poi.setTile({
				x: x,
				y: tlY - 1,
			}, getDirtTile());
			poi.setTile({
				x: x,
				y: tlY + roomHeight,
			}, getDirtTile());
		}

		for (y in tlY...(tlY + roomHeight))
		{
			poi.setTile({
				x: tlX - 1,
				y: y,
			}, getDirtTile());
			poi.setTile({
				x: tlX + roomWidth,
				y: y,
			}, getDirtTile());
		}

		var r = new Room(tlX, tlY, roomWidth, roomHeight);

		return [r];
	}

	private function getDirtTile()
	{
		var tile:RoomTile = {
			content: [],
			tileKey: TERRAIN_BASIC_5,
			primary: C_DARK_RED,
			background: C_WOOD,
		};
		return tile;
	}
}
