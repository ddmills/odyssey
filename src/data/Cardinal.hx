package data;

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

	public static function fromDegrees(degrees:Float):Cardinal
	{
		var d = degrees - 22.5;
		var val = (d / 45).round();

		switch val
		{
			case 0:
				return NORTH;
			case 1:
				return NORTH_EAST;
			case 2:
				return EAST;
			case 3:
				return SOUTH_EAST;
			case 4:
				return SOUTH;
			case 5:
				return SOUTH_WEST;
			case 6:
				return WEST;
			case 7:
				return NORTH_WEST;
			case _:
				return WEST;
		}
	}

	static function get_values():Array<Cardinal>
	{
		return [NORTH_WEST, NORTH, NORTH_EAST, WEST, EAST, SOUTH_WEST, SOUTH_EAST, SOUTH];
	}
}
