package domain.terrain.gen;

import common.struct.Grid;
import common.struct.IntPoint;

@:structInit class Room
{
	public var tiles:Grid<RoomTile>;
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var offsetX:Int;
	public var offsetY:Int;
	public var includeWalls:Bool;
	public var portals:Array<String>;

	public function new(offsetX:Int, offsetY:Int, width:Int, height:Int)
	{
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.width = width;
		this.height = height;
		this.includeWalls = true;
		this.portals = [];

		tiles = new Grid(width, height);
	}

	public function getTile(pos:IntPoint):Null<RoomTile>
	{
		return tiles.get(pos.x, pos.y);
	}

	public function getTileByZonePos(pos:IntPoint):Null<RoomTile>
	{
		return tiles.get(pos.x - offsetX, pos.y - offsetY);
	}

	public function isOnEdge(pos:IntPoint):Bool
	{
		return pos.x == 0 || pos.x == width - 1 || pos.y == 0 || pos.y == height - 1;
	}

	public function getEmptyTiles():Array<GridItem<RoomTile>>
	{
		return tiles.filter((t) -> t.value.content.isEmpty());
	}
}
