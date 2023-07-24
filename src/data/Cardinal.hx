package data;

import common.struct.IntPoint;

@:enum
enum abstract Cardinal(Int) to Int from Int
{
	var NORTH = 0;
	var NORTH_EAST = 1;
	var EAST = 2;
	var SOUTH_EAST = 3;
	var SOUTH = 4;
	var SOUTH_WEST = 5;
	var WEST = 6;
	var NORTH_WEST = 7;
	public static var values(get, never):Array<Cardinal>;

	@:to
	public function toInt():Int
	{
		return this;
	}

	public static function fromRadians(radians:Float):Cardinal
	{
		var val = (radians / (Math.PI / 4)).round();

		return switch val
		{
			case 0: EAST;
			case 1: SOUTH_EAST;
			case 2: SOUTH;
			case 3: SOUTH_WEST;
			case 4: WEST;
			case 5: NORTH_WEST;
			case 6: NORTH;
			case 7: NORTH_EAST;
			case _: EAST;
		}
	}

	public static function fromDegrees(degrees:Float):Cardinal
	{
		var val = (degrees / 45).round();

		return switch val
		{
			case 0: EAST;
			case 1: SOUTH_EAST;
			case 2: SOUTH;
			case 3: SOUTH_WEST;
			case 4: WEST;
			case 5: NORTH_WEST;
			case 6: NORTH;
			case 7: NORTH_EAST;
			case _: EAST;
		}
	}

	static function get_values():Array<Cardinal>
	{
		return [NORTH_WEST, NORTH, NORTH_EAST, WEST, EAST, SOUTH_WEST, SOUTH_EAST, SOUTH];
	}
}
