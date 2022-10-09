package domain.terrain.gen;

import common.struct.Grid;
import common.struct.IntPoint;
import common.tools.Performance;
import core.Game;
import data.PoiType;
import domain.terrain.MapData.PoiTemplate;

typedef ZonePoiSave =
{
	zoneId:Int,
	type:PoiType,
	tileOverrides:GridSave<RoomTile>,
	isGenerated:Bool,
	template:PoiTemplate,
	rooms:Array<Room>,
}

class ZonePoi
{
	public var zoneId:Int;
	public var rooms:Array<Room>;
	public var tileOverrides:Grid<RoomTile>;

	public var template(default, null):PoiTemplate;
	public var type(default, null):PoiType;

	public var width(get, never):Int;
	public var height(get, never):Int;

	public var isGenerated(default, null):Bool;

	public function new(zoneId:Int, template:PoiTemplate)
	{
		this.zoneId = zoneId;
		this.rooms = [];
		this.template = template;
		this.type = template.type;
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

	public function save():ZonePoiSave
	{
		return {
			zoneId: zoneId,
			type: type,
			tileOverrides: tileOverrides.save((t) -> t),
			isGenerated: isGenerated,
			template: template,
			rooms: rooms,
		};
	}

	public static function Load(data:ZonePoiSave):ZonePoi
	{
		var poi = new ZonePoi(data.zoneId, data.template);
		poi.type = data.type;
		poi.tileOverrides.load(data.tileOverrides, (t) -> t);
		poi.isGenerated = data.isGenerated;
		poi.rooms = data.rooms;

		return poi;
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
