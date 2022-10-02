package domain.terrain.gen;

import common.struct.Grid;
import common.struct.IntPoint;
import common.tools.Performance;
import core.Game;
import domain.terrain.MapData.PoiTemplate;

class ZonePoi
{
	public var zoneId:Int;
	public var rooms:Array<Room>;
	public var tileOverrides:Grid<RoomTile>;

	public var template(default, null):PoiTemplate;

	public var width(get, never):Int;
	public var height(get, never):Int;

	public var isGenerated(default, null):Bool;

	public function new(zoneId:Int, template:PoiTemplate)
	{
		this.zoneId = zoneId;
		this.rooms = [];
		this.template = template;
		tileOverrides = new Grid(width, height);
	}

	public function get_width():Int
	{
		return Game.instance.world.zoneSize;
	}

	public function get_height():Int
	{
		return Game.instance.world.zoneSize;
	}

	public function generate()
	{
		if (isGenerated)
		{
			return;
		}

		Performance.start('poi-generate');
		PoiGenerator.Generate(this);
		Performance.stop('poi-generate', true);

		isGenerated = true;
	}

	public function setTile(p:IntPoint, tile:RoomTile)
	{
		tileOverrides.set(p.x, p.y, tile);
	}

	public function getTile(p:IntPoint)
	{
		var tileOverride = tileOverrides.get(p.x, p.y);

		if (tileOverride != null)
		{
			return tileOverride;
		}

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
