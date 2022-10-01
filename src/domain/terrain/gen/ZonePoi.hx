package domain.terrain.gen;

import common.struct.IntPoint;
import core.Game;

class ZonePoi
{
	public var zoneId:Int;
	public var rooms:Array<Room>;
	public var width(get, never):Int;
	public var height(get, never):Int;

	public var isGenerated:Bool;

	public function new(zoneId:Int)
	{
		this.zoneId = zoneId;
		this.rooms = [];
	}

	public function get_width():Int
	{
		return Game.instance.world.zoneSize;
	}

	public function get_height():Int
	{
		return Game.instance.world.zoneSize;
	}

	public function getTile(p:IntPoint)
	{
		for (room in rooms)
		{
			var tile = room.getTileByZonePos(p);
			if (tile != null)
			{
				return tile;
			}
		}

		return null;
	}

	public function getRoom(p:IntPoint)
	{
		for (room in rooms)
		{
			var tile = room.getTileByZonePos(p);
			if (tile != null)
			{
				return room;
			}
		}

		return null;
	}
}
