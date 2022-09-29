package domain.terrain;

import common.struct.Grid;
import common.struct.IntPoint;
import core.Game;

class ZoneManager
{
	public var zones:Grid<Zone>;
	public var zoneCountX(get, never):Int;
	public var zoneCountY(get, never):Int;
	public var game(get, never):Game;

	public function new()
	{
		zones = new Grid();
	}

	public function initialize()
	{
		zones = new Grid(zoneCountX, zoneCountY);
		zones.fillFn((idx) -> new Zone(idx));
	}

	inline public function getChunksForZone(zoneId:Int)
	{
		return zones.getAt(zoneId).getChunks();
	}

	public function getZone(pos:IntPoint)
	{
		return zones.get(pos.x, pos.y);
	}

	public function getZoneById(idx:Int)
	{
		return zones.getAt(idx);
	}

	public function getZoneId(pos:IntPoint)
	{
		return zones.idx(pos.x, pos.y);
	}

	public function getZonePos(idx:Int)
	{
		return zones.coord(idx);
	}

	public function isOutOfBounds(pos:IntPoint):Bool
	{
		return zones.isOutOfBounds(pos.x, pos.y);
	}

	inline function get_zoneCountX():Int
	{
		return game.world.zoneCountX;
	}

	inline function get_zoneCountY():Int
	{
		return game.world.zoneCountY;
	}

	inline function get_game():Game
	{
		return Game.instance;
	}
}
