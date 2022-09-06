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

	public static function fromDegrees(degrees:Float):Cardinal
	{
		var val = (degrees / 45).floor();

		switch val
		{
			case 1:
				return NORTH;
			case 2:
				return NORTH_EAST;
			case 3:
				return EAST;
			case 4:
				return SOUTH_EAST;
			case 5:
				return SOUTH;
			case 6:
				return SOUTH_WEST;
			case 7:
				return WEST;
			case 0:
				return NORTH_WEST;
			case _:
				return WEST;
		}
	}

	@:to
	public function toInt():Int
	{
		return this;
	}

	static function get_values():Array<Cardinal>
	{
		return [NORTH_WEST, NORTH, NORTH_EAST, WEST, EAST, SOUTH_WEST, SOUTH_EAST, SOUTH];
	}
}
